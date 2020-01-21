
# get the path to an example CSV file from the readr package
csv_file <- readr::readr_example("mtcars.csv")


# read the CSV with base R's read.csv function with default options
read.csv(csv_file)

# check what the default option for read.csv's fileEncoding option
getOption("encoding")
Sys.getlocale("LC_CTYPE")

# setting the fileEncoding explicitly
read.csv(csv_file, fileEncoding = "ASCII")
read.csv(csv_file, fileEncoding = "UTF-8")

# try writing a file with default settings
csv_data <- read.csv(csv_file, fileEncoding = "ASCII")
write.csv(csv_data, file.path(tempdir(), "unknown_encoding.csv"))

# write with explicit fileEncoding
write.csv(csv_data, file.path(tempdir(), "utf8.csv"), fileEncoding = "UTF-8")




# try the readr packages equivalents
readr::read_csv(csv_file)

readr::read_csv(csv_file, locale = locale(encoding = "ASCII"))
readr::read_csv(csv_file, locale = locale(encoding = "UTF-8"))

csv_data <- readr::read_csv(csv_file, locale = locale(encoding = "ASCII"))
readr::write_csv(csv_data, file.path(tempdir(), "unknown_encoding_readr.csv"))


# guess the encoding of a file
# stringi::stri_enc_detect()
readr::guess_encoding(csv_file)
readr::guess_encoding(file, n_max = 10000, threshold = 0.2)
readr::guess_encoding(csv_file, n_max = -1, threshold = 0.8)

readr::guess_encoding(file.path(tempdir(), "unknown_encoding_readr.csv"))

readr::guess_encoding("a\n\u00b5\u00b5")



# experiment with writing files
df <- data.frame(a = letters[1:4], b = LETTERS[1:4])
df
tmpfile <- file.path(tempdir(), "test.csv")

write.csv(df, tmpfile)
readr::guess_encoding(tmpfile)
read.csv(tmpfile)
read.csv(tmpfile, fileEncoding = "UTF-8")
readr::read_csv(tmpfile)
readr::read_csv(tmpfile, locale = locale(encoding = "windows-1250"))
readr::read_csv(tmpfile, locale = locale(encoding = "UTF-8"))


# try with explicitly Windows-1252
write.csv(df, tmpfile, fileEncoding = "windows-1252")
readr::guess_encoding(tmpfile)
read.csv(tmpfile)
read.csv(tmpfile, fileEncoding = "UTF-8")
readr::read_csv(tmpfile)
readr::read_csv(tmpfile, locale = locale(encoding = "windows-1250"))
readr::read_csv(tmpfile, locale = locale(encoding = "UTF-8"))



# now start adding weird characters
df <- data.frame(könig = letters[1:4], test = c("2°", "µ", "漢字", "😎"))
tmpfile <- file.path(tempdir(), "test.csv")


write.csv(df, tmpfile)
readr::guess_encoding(tmpfile)
read.csv(tmpfile)
read.csv(tmpfile, fileEncoding = "UTF-8")
readr::read_csv(tmpfile)
readr::read_csv(tmpfile, locale = locale(encoding = "windows-1250"))
readr::read_csv(tmpfile, locale = locale(encoding = "UTF-8"))



write.csv(df, tmpfile, fileEncoding = "windows-1250")
readr::guess_encoding(tmpfile)
readr::read_csv(tmpfile, locale = locale(encoding = "windows-1250"))
readr::read_csv(tmpfile, locale = locale(encoding = "UTF-8"))
readr::read_csv(tmpfile, locale = locale(encoding = "ISO-8859-2"))
readr::read_csv(tmpfile, locale = locale(encoding = "ISO-8859-1"))
readr::read_csv(tmpfile)


# explicitly set UTF-8 when writing
write.csv(df, tmpfile, fileEncoding = "UTF-8")
readr::guess_encoding(tmpfile)
readr::read_csv(tmpfile, locale = locale(encoding = "windows-1250"))
readr::read_csv(tmpfile, locale = locale(encoding = "UTF-8"))


# check the locale/encoding of your Console
Sys.getlocale("LC_CTYPE")
