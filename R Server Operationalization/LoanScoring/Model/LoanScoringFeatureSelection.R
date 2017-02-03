install.packages(c("reshape2","ggplot2","ROCR","plyr","Rcpp","stringr","stringi","magrittr","digest","gtable",
                   "proto","scales","munsell","colorspace","labeling","gplots","gtools","gdata","caTools","bitops"))

library(reshape2)
library(ggplot2)

# creating output directory
mainDir <- '[SET OUTPUT DIRECTORY]' 
dir.create(mainDir, recursive = TRUE, showWarnings = FALSE)  
setwd(mainDir);  
print("Creating output plot files:", quote=FALSE)  


# Open a jpeg file and output ggplot in that file.  

dest_filename = tempfile(pattern = 'ggplot_', tmpdir = mainDir)  
dest_filename = paste(dest_filename, '.jpg',sep="")  
print(dest_filename, quote=FALSE);
jpeg(filename=dest_filename, height=3900, width = 6400, res=300); 

#filtering numeric columns
loans <- read.csv("https://raw.githubusercontent.com/Microsoft/microsoft-r/master/R%20Server%20Operationalization/LoanScoring/Data/SampleLoanData.csv")
numeric_cols <- sapply(loans, is.numeric)

numeric_cols

#turn the data into long format (key->value)
loans.lng <- melt(loans[,numeric_cols], id="is_bad")


#plot the distribution for is_bad={0/1} for each numeric column

print(ggplot(aes(x=value, group=is_bad, colour=factor(is_bad)), data=loans.lng) + geom_density() + facet_wrap(~variable, scales="free"))
#dev.off()

#revol_util, int_rate, mths_since_last_record, annual_inc_joint, dti_joint, total_rec_prncp, all_util
