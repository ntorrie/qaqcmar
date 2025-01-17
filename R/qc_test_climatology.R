
#' Add flag column for the climatology test
#'
#' @param dat Data.frame with at least one column \code{timestamp}.
#'
#' @return placeholder for now
#'
#' @importFrom dplyr %>% case_when mutate stringr
#'
#' @export





qc_test_climatology <- function(dat) {
  dat %>%
    mutate(
      mutate(
        SEASON = case_when(
          month(TIMESTAMP) == 12|
            month(TIMESTAMP) == 1|
            month(TIMESTAMP) == 2 ~ "Winter",
          month(TIMESTAMP) == 3|
            month(TIMESTAMP) == 4|
            month(TIMESTAMP) == 5 ~ "Spring",
          month(TIMESTAMP) == 6|
            month(TIMESTAMP) == 7|
            month(TIMESTAMP) == 8 ~ "Summer",
          month(TIMESTAMP) == 9|
            month(TIMESTAMP) == 10|
            month(TIMESTAMP) == 11 ~ "Fall"
        )) %>%
        mutate(
          seasonmax = case_when(
            #winter
            SEASON == "Winter" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 120, #aquaMeasure DOT DO
            SEASON == "Winter" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 15, #Hobo DO DO
            SEASON == "Winter" & VARIABLE == "Temperature" ~ 15, #ALL temp
            SEASON == "Winter" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
            #spring
            SEASON == "Spring" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 130, #aquaMeasure DOT DO
            SEASON == "Spring" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 20, #Hobo DO DO
            SEASON == "Spring" & VARIABLE == "Temperature" ~ 20, #ALL temp
            SEASON == "Spring" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
            #summer
            SEASON == "Summer" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 130, #aquaMeasure DOT DO
            SEASON == "Summer" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 20, #Hobo DO DO
            SEASON == "Summer" & VARIABLE == "Temperature" ~ 25, #ALL temp
            SEASON == "Summer" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
            #fall
            SEASON == "Fall" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 120, #aquaMeasure DOT DO
            SEASON == "Fall" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 15, #Hobo DO DO
            SEASON == "Fall" & VARIABLE == "Temperature" ~ 20, #ALL temp
            SEASON == "Fall" & VARIABLE == "Salinity" ~ 40 #aquaMeasure SAL
          )) %>%
        mutate(
          seasonmin = case_when(
            #winter
            SEASON == "Winter" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 70, #aquaMeasure DOT DO
            SEASON == "Winter" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 2, #Hobo DO DO
            SEASON == "Winter" & VARIABLE == "Temperature" ~ -0.75, #ALL temp
            SEASON == "Winter" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
            #spring
            SEASON == "Spring" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 70, #aquaMeasure DOT DO
            SEASON == "Spring" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 5, #Hobo DO DO
            SEASON == "Spring" & VARIABLE == "Temperature" ~ 0, #ALL temp
            SEASON == "Spring" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
            #summer
            SEASON == "Summer" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 70, #aquaMeasure DOT DO
            SEASON == "Summer" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 10, #Hobo DO DO
            SEASON == "Summer" & VARIABLE == "Temperature" ~ 7, #ALL temp
            SEASON == "Summer" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
            #fall
            SEASON == "Fall" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 70, #aquaMeasure DOT DO
            SEASON == "Fall" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 2, #Hobo DO DO
            SEASON == "Fall" & VARIABLE == "Temperature" ~ 5, #ALL temp
            SEASON == "Fall" & VARIABLE == "Salinity" ~ 40 #aquaMeasure SAL
          ))%>%
        mutate(
          flag = case_when(
            VALUE > seasonmax |
              VALUE < seasonmin ~ 3,
            VALUE <= seasonmax |
              VALUE >= seasonmin ~ 1,
            TRUE ~ 2
          )) %>%
        mutate(flag = factor(flag)) %>%
        # assign levels to the factor based on the numeric values of flag
        mutate(flag = ordered(flag,
                              levels = as.numeric(levels(flag))[order(as.numeric(levels(flag)))])) %>%
        #remove extra columns
        subset(select = -c(seasonmax,seasonmin))%>%
        mutate(TIMESTAMP = parse_date_time(TIMESTAMP,
                                           orders= c("dmY HM", "dmY HMS",
                                                     "mdY HM", "mdY HMS",
                                                     "Ymd HM", "Ymd HMS")))

    )
}





#
# ##test the function
# #read in file with outliers to test each flag
# # dat<-read.csv("C:/Users/Nicole Torrie/Documents/R/test_qaqc_dataset/Colchester_2021-12-09_QAQC.csv")
# library(dplyr)
# library(stringr)
# library(lubridate)
#
#
#
# dat2 <- dat %>%
#   mutate(
#     SEASON = case_when(
#       month(TIMESTAMP) == 12|
#       month(TIMESTAMP) == 1|
#       month(TIMESTAMP) == 2 ~ "Winter",
#       month(TIMESTAMP) == 3|
#       month(TIMESTAMP) == 4|
#       month(TIMESTAMP) == 5 ~ "Spring",
#       month(TIMESTAMP) == 6|
#       month(TIMESTAMP) == 7|
#       month(TIMESTAMP) == 8 ~ "Summer",
#       month(TIMESTAMP) == 9|
#       month(TIMESTAMP) == 10|
#       month(TIMESTAMP) == 11 ~ "Fall"
#     )) %>%
#   mutate(
#     seasonmax = case_when(
#       #winter
#       SEASON == "Winter" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 120, #aquaMeasure DOT DO
#       SEASON == "Winter" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 15, #Hobo DO DO
#       SEASON == "Winter" & VARIABLE == "Temperature" ~ 15, #ALL temp
#       SEASON == "Winter" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
#       #spring
#       SEASON == "Spring" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 130, #aquaMeasure DOT DO
#       SEASON == "Spring" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 20, #Hobo DO DO
#       SEASON == "Spring" & VARIABLE == "Temperature" ~ 20, #ALL temp
#       SEASON == "Spring" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
#       #summer
#       SEASON == "Summer" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 130, #aquaMeasure DOT DO
#       SEASON == "Summer" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 20, #Hobo DO DO
#       SEASON == "Summer" & VARIABLE == "Temperature" ~ 25, #ALL temp
#       SEASON == "Summer" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
#       #fall
#       SEASON == "Fall" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 120, #aquaMeasure DOT DO
#       SEASON == "Fall" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 15, #Hobo DO DO
#       SEASON == "Fall" & VARIABLE == "Temperature" ~ 20, #ALL temp
#       SEASON == "Fall" & VARIABLE == "Salinity" ~ 40 #aquaMeasure SAL
#     )) %>%
#   mutate(
#     seasonmin = case_when(
#       #winter
#       SEASON == "Winter" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 70, #aquaMeasure DOT DO
#       SEASON == "Winter" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 2, #Hobo DO DO
#       SEASON == "Winter" & VARIABLE == "Temperature" ~ -0.75, #ALL temp
#       SEASON == "Winter" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
#       #spring
#       SEASON == "Spring" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 70, #aquaMeasure DOT DO
#       SEASON == "Spring" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 5, #Hobo DO DO
#       SEASON == "Spring" & VARIABLE == "Temperature" ~ 0, #ALL temp
#       SEASON == "Spring" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
#       #summer
#       SEASON == "Summer" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 70, #aquaMeasure DOT DO
#       SEASON == "Summer" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 10, #Hobo DO DO
#       SEASON == "Summer" & VARIABLE == "Temperature" ~ 7, #ALL temp
#       SEASON == "Summer" & VARIABLE == "Salinity" ~ 40, #aquaMeasure SAL
#       #fall
#       SEASON == "Fall" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "aquaMeasure") == TRUE ~ 70, #aquaMeasure DOT DO
#       SEASON == "Fall" & VARIABLE == "Dissolved Oxygen" & str_detect(dat$SENSOR, "HOBO") == TRUE ~ 2, #Hobo DO DO
#       SEASON == "Fall" & VARIABLE == "Temperature" ~ 5, #ALL temp
#       SEASON == "Fall" & VARIABLE == "Salinity" ~ 40 #aquaMeasure SAL
#     ))%>%
#   mutate(
#     flag = case_when(
#       VALUE > seasonmax |
#       VALUE < seasonmin ~ 3,
#       VALUE <= seasonmax |
#       VALUE >= seasonmin ~ 1,
#       TRUE ~ 2
#     )) %>%
#   mutate(flag = factor(flag)) %>%
#   # assign levels to the factor based on the numeric values of flag
#   mutate(flag = ordered(flag,
#                         levels = as.numeric(levels(flag))[order(as.numeric(levels(flag)))])) %>%
#   mutate(TIMESTAMP = parse_date_time(TIMESTAMP,
#                                      orders= c("dmY HM", "dmY HMS",
#                                                "mdY HM", "mdY HMS",
#                                                "Ymd HM", "Ymd HMS")))
#
#
# #unique(dat2$flag)
#
#
#
# # #test plots
# DO <- filter(dat2,VARIABLE == "Dissolved Oxygen", preserve=TRUE)
# TEMPam <- filter(dat2,VARIABLE == "Temperature" & str_detect(dat2$SENSOR, "aquaMeasure"), preserve=TRUE)
# TEMPhobo <- filter(dat2,VARIABLE == "Temperature" & str_detect(dat2$SENSOR, "HOBO"), preserve=TRUE)
# TEMPvr <- filter(dat2,VARIABLE == "Temperature" & str_detect(dat2$SENSOR, "VR2AR"), preserve=TRUE)
#
#
# ggplot(TEMPhobo, aes(TIMESTAMP, VALUE, colour = flag))+
#   geom_point()+
#   scale_color_manual(values=c("green", "orange"))+
#   ggtitle(TEMPhobo$VARIABLE)


