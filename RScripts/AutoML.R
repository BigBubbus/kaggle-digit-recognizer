# super easy first way to do some machine learning using h2o's autoML
library(h2o)

h2o.init()

training <- read.csv(file="./data/train.csv",head=TRUE,sep=",")
testing  <- read.csv(file="./data/test.csv",head=TRUE,sep=",")

y <- "label"
x <- setdiff(names(training), y)

training[,y] <- as.factor(training[,y])

aml <- h2o.automl(x = x, y = y,
                  training_frame = as.h2o(training),
                  max_models = 1000)

pred <- h2o.predict(aml, as.h2o(testing))  # predict(aml, test) also works
result <- as.data.frame(pred$pred)
result$ImageId <- seq.int(nrow(result))
result <- result[,c("ImageId","predict")]
colnames(result) <- c("ImageId","label")

head(result)
write.csv(result, file = "submissionAutoML.csv", row.names = FALSE)
