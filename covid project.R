library(dplyr)
library(SEIRfansy)
library(readr)

covid=read_csv("https://raw.githubusercontent.com/ZachChen213/123/main/master.csv")

train = covid[672:730,] #2022 JAN 1ST-FEB 28TH (59 data points)
test = covid[731:755,] #2022 MARCH 1ST-MARCH 25TH (25 data points)

train_multinom = train %>%
  rename(Confirmed = Daily.Confirmed, Recovered = Daily.Recovered, Deceased = Daily.Deceased) %>%
  dplyr::select(Confirmed, Recovered, Deceased)
test_multinom =
  test %>%
  rename(Confirmed = Daily.Confirmed,
         Recovered = Daily.Recovered,
         Deceased = Daily.Deceased) %>% dplyr::select(Confirmed, Recovered, Deceased)

N = 9934710 # population size of LA 2022
data_initial = c(1733526,1445460,26362,10773,2744,21)# Total Confirmed, Total Recov- ered, Total Death, Daily Confirmed, Daily Recovered, and Daily Death for the Starting Date
pars_start = c(c(0.8,0.8,0.8,0.8,0.8), c(0.2,0.2,0.2,0.2,0.2)) 
phases = c(1,12,24,36,48)

cov19pred = SEIRfansy.predict(data = train_multinom, init_pars = pars_start, data_init = data_initial, T_predict = 60, niter = 1e3,
                              BurnIn = 1e2, data_test = test_multinom, model = "Multinomial", N = N, lambda = 1/(69.416 * 365), mu = 1/(69.416 * 365), period_start = phases, opt_num = 1,
                              auto.initialize = TRUE, f = 0.15)

#name(cov19pred)
#class(cov19pred$prediction) class(cov19pred$mcmc_pars) names(cov19pred$plots)
plot(cov19pred, type = "trace")
plot(cov19pred, type = "boxplot")
plot(cov19pred, type = "panel")
plot(cov19pred, type = "cases")

