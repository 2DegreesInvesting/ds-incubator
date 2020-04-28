# Get data directly from the database 

<https://github.com/2DegreesInvesting/ds-incubator/issues/40>

## Code shown live

### File "test\_db\_portcheck.R"

```r
library(dplyr)
library(dbplyr)
library(readr)
library(fs)
library(tictoc)


# Connection functions

connect_datastore <-
  function(data_quarter = '_2019q4') {
    require(DBI)
    require(RPostgres)

    if (is.null(getOption('2dii_datastore_pwd'))) {
      set_datastore_pwd()
    }

    DBI::dbConnect(
      drv = RPostgres::Postgres(),
      dbname = 'twodii',
      host = 'twodii-gocd.westeurope.cloudapp.azure.com',
      user = 'twodii-reader',
      password = getOption('2dii_datastore_pwd'),
      options = paste0('-c search_path=', data_quarter, ',public')
    )
  }


set_datastore_pwd <-
  function() {
    require(rstudioapi)
    options('2dii_datastore_pwd' = rstudioapi::askForPassword('Database password'))
  }



# Access

dropbox_path <- fs::path('~/Dropbox (2° Investing)')
project_path_rds <- fs::path('PortCheck/00_Data/07_AnalysisInputs/2019Q4_250220')
fin_data_rds <- read_rds(fs::path(dropbox_path, project_path_rds, 'security_financial_data.rda'))
fin_data_rds


dropbox_path <- fs::path('~/Dropbox (2° Investing)')
project_path_csv <- fs::path('PortCheck/00_Data/06_DataStore/2019Q4_export_04232020/2019Q4')
fin_data_csv <- read_csv(fs::path(dropbox_path, project_path_csv, 'security_financial_data.csv'))
fin_data_csv


datastore <- connect_datastore(data_quarter = '_2019q4')
fin_data_db <- tbl(datastore, 'security_financial_data')
fin_data_db


# Advantages:
#   1. Doesn't depend on the name of the Dropbox folder
#   2. Don't have to figure out the proper filepath
#   3. Don't have to worry about cross-platform filepath formatting
#   4. Don't have to be connected to Dropbox at all
#   5. Don't have to worry about column types (read_csv)
#   6. Explicit paths make packaging the code for other uses very difficult

# Disadvantage:
#   1. Does require internet access (potentially worked around by implementing
#      a caching system)



# Speed

tic()
fin_data_rds <- read_rds(fs::path(dropbox_path, project_path_rds, 'security_financial_data.rda'))
fin_data_rds
toc()


tic()
fin_data_csv <- read_csv(fs::path(dropbox_path, project_path_csv, 'security_financial_data.csv'))
fin_data_csv
toc()


tic()
fin_data_db <- tbl(datastore, 'security_financial_data')
fin_data_db
toc()


tic()
fin_data_db <- tbl(datastore, 'security_financial_data')
fin_data_db %>% collect()
toc()


tic()
fin_data_db <- tbl(datastore, 'security_financial_data')
fin_data_db %>%
  select(company_id, bloomberg_id, company_name, isin, security_bics_subgroup) %>%
  collect()
toc()


# Disadvantage:
#   1. Has to download the data over the internet, but... if you specify only
#      the parts of the data you need, it can still be pretty fast, even faster
#      than reading in the whole local file under certain circumstances



# PACTA analysis
# get_and_clean_fin_data()

source('simulate_portcheck_code.R')


tic()
fin_data_rds <- read_rds(fs::path(dropbox_path, project_path_rds, 'security_financial_data.rda'))
clean_fin_data(fin_data_rds)
toc()


tic()
fin_data_csv <- read_csv(fs::path(dropbox_path, project_path_csv, 'security_financial_data.csv'))
clean_fin_data(fin_data_csv)
toc()


tic()
fin_data_db <- tbl(datastore, 'security_financial_data')
clean_fin_data(fin_data_db)
toc()


tic()
fin_data_db <- tbl(datastore, 'security_financial_data')
clean_fin_data(fin_data_db) %>% collect()
toc()



# Advanced usage

fin_data_db <- tbl(datastore, 'security_financial_data')


bics_sub_lookup <- fin_data_db %>% select(isin, security_bics_subgroup)
company_name_lookup <- fin_data_db %>% select(isin, company_name)
coupon_value_lookup <- fin_data_db %>% select(isin, coupon_value)


bics_sub_lookup
company_name_lookup
coupon_value_lookup


bics_sub_lookup %>% collect()
company_name_lookup %>% collect()
coupon_value_lookup %>% collect()


isins <- fin_data_db %>% select(isin) %>% collect() %>% filter(!is.na(isin))
isins <- isins[sample(1:nrow(isins), 20), ]
isins


isins %>% left_join(bics_sub_lookup, copy = TRUE) %>% print(n = 20)

isins %>% left_join(company_name_lookup, copy = TRUE) %>% print(n = 20)

isins %>% left_join(coupon_value_lookup, copy = TRUE) %>% print(n = 20)


isins %>% left_join(fin_data_db %>% select(isin, company_name), copy = TRUE) %>% print(n = 20)



# disconnet!!!

dbDisconnect(datastore)
```

### File "simulate\_portcheck\_code.R"

```r
library(readr)
library(dplyr)

overrides <-
  read_csv("https://raw.githubusercontent.com/2DegreesInvesting/PACTA_analysis/master/data/fin_sector_overrides.csv", col_types = "ccdc") %>%
  mutate_at(vars(company_name, corporate_bond_ticker,fin_sector_override), list(as.character)) %>%
  mutate(sector_override = TRUE)
overrides_cbt <-
  overrides %>%
  filter(corporate_bond_ticker != "" , !is.na(corporate_bond_ticker)) %>%
  select(corporate_bond_ticker, fin_sector_override, sector_override) %>%
  distinct()
overrides_bbg <-
  overrides %>%
  filter(is.na(corporate_bond_ticker)|corporate_bond_ticker == "")%>%
  select(bloomberg_id, fin_sector_override, sector_override) %>%
  distinct()

sector_bridge <- read_csv("https://raw.githubusercontent.com/2DegreesInvesting/PACTA_analysis/master/data/sector_bridge.csv", col_types = "ccc")

cb_groups <- c("Convertible bonds", "Corporate Bonds", "Corporate inflation linked Bonds")
sb_groups <- c("Sovereign Debt","Sovereign Agency Debt", "Government inflation linked Bonds", "Sovereign","Sovereign Agency", "Sovereigns")


clean_fin_data <-
  function(input_data) {
    input_data %>%
      left_join(sector_bridge %>% filter(source == "BICS") %>% select(-source),
                by = c("security_bics_subgroup" = "industry_classification"),
                copy = TRUE) %>%
      filter(!is.na(sector)) %>%
      select(-security_mapped_sector) %>%
      rename(security_mapped_sector = sector) %>%
      left_join(overrides_cbt, by = "corporate_bond_ticker", copy = TRUE) %>%
      left_join(overrides_bbg, by = "bloomberg_id", copy = TRUE) %>%
      mutate(sector_override = sector_override.x,
             sector_override = if_else(sector_override.y != ""&!is.na(sector_override.y), sector_override.y, sector_override),
             fin_sector_override = fin_sector_override.x,
             fin_sector_override = if_else(!is.na(fin_sector_override.y)&fin_sector_override.y != "", fin_sector_override.y, fin_sector_override),
             sector_override = if_else(is.na(sector_override),FALSE,TRUE)) %>%
      select(-sector_override.x, -sector_override.y, -fin_sector_override.x, -fin_sector_override.y) %>%
      mutate(security_mapped_sector = if_else(sector_override, fin_sector_override, security_mapped_sector)) %>%
      select(-fin_sector_override) %>%
      mutate(asset_type = if_else(asset_type == "Other", "Others", asset_type),
             asset_type = if_else(is.na(asset_type), "Others", asset_type)) %>%
      mutate(asset_type = paste0(toupper(substr(asset_type,1,1)),tolower(substr(asset_type,2,nchar(asset_type))))) %>%
      mutate(security_mapped_sector = case_when(security_mapped_sector == "Others" ~ "Other",
                                                security_mapped_sector == "OIl&Gas" ~ "Oil&Gas",
                                                TRUE ~ security_mapped_sector)) %>%
      mutate(asset_type = if_else(security_type %in% cb_groups,"Bonds",asset_type)) %>%
      mutate(is_sb = case_when(security_type %in% sb_groups ~ TRUE,
                               security_bics_subgroup %in% sb_groups ~ TRUE,
                               TRUE ~ FALSE)) %>%
      mutate(asset_type = case_when(grepl("Fund", security_type) ~ "Funds" ,
                                    grepl("ETF", security_type) ~ "Funds",
                                    grepl("Fund", security_bclass4) ~ "Funds" ,
                                    grepl("ETF", security_bclass4) ~ "Funds",
                                    grepl("Fund", security_icb_subsector) ~ "Funds" ,
                                    grepl("ETF", security_icb_subsector) ~ "Funds",
                                    TRUE ~ asset_type)) %>%
      select(
        company_id, company_name,bloomberg_id,corporate_bond_ticker,
        country_of_domicile,
        isin,
        unit_share_price, exchange_rate_usd,
        asset_type, security_type,
        security_mapped_sector, security_icb_subsector, security_bics_subgroup,
        maturity_date, coupon_value, amount_issued, current_shares_outstanding_all_classes, unit_share_price,
        sector_override,
        is_sb
      )
  }

```
