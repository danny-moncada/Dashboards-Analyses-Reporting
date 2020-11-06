#### DiD Regression ####

library(plm)
library(dplyr)
library(ggplot2)

#### Load the data ####
data = read.csv("TSTV-Obs-Dataset.csv")
# As descriptive visualization, let's look at average weekly viewership for both premium and regular viewers
week_ave = data %>% group_by(week, premium) %>%
  summarise(ave_view = mean(view_time_total_hr)) %>% ungroup()
ggplot(week_ave, aes(x = week, y = ave_view, color = factor(premium))) + 
  geom_line() + 
  geom_vline(xintercept = 2227, linetype='dotted') + 
  ylim(0, 6) + xlim(2220,2233) + 
  theme_bw()


#### Difference in Differences Regression ####
# Interpret the treatment effect
did_basic = lm(log(view_time_total_hr+1) ~ premium + after + premium*after, data=data)
summary(did_basic)


# Let's try replacing the treatment dummy with subject fixed effects.
# What happened to the estimate of premium?
did_fe = plm(log(view_time_total_hr+1) ~ premium + after + premium*after, data = data, index=c("id"), effect="individual", model="within")
summary(did_fe)

# Further add week fixed effects
did_sfe_tfe = plm(log(view_time_total_hr+1) ~ premium + after + premium*after, data = data, index=c("id", "week"), effect="twoway", model="within")
summary(did_sfe_tfe)


# Let's try dynamic DiD instead.
did_dyn_sfe_tfe <- lm(log(view_time_total_hr+1) ~ premium + factor(week) + premium*factor(week), data = data)
summary(did_dyn_sfe_tfe)

# Let's retrieve the coefficients and standard errors, and create confidence intervals
model = summary(did_dyn_sfe_tfe)
coefs_ses = as.data.frame(model$coefficients[16:28,c("Estimate", "Std. Error")])
colnames(coefs_ses) = c("beta", "se")
coefs_ses = coefs_ses %>%
  mutate(ub90 = beta + 1.96*se,
         lb90 = beta - 1.96*se,
         week = 1:nrow(coefs_ses))

# Let's connect the estimates with a line and include a ribbon for the CIs. 
ggplot(coefs_ses, aes(x = week, y = beta)) + 
  geom_line() + 
  geom_hline(yintercept=0,linetype="dashed") + 
  geom_vline(xintercept=6,linetype="dashed") + 
  geom_ribbon(aes(ymin = lb90, ymax = ub90), alpha = 0.3) + 
  theme_bw()


# Time for our placebo test... 
# Let's shift the treatment date back in time (e.g., to week 2228), artificially, and estimate the "treatment" effect
data_placebo = data %>%
  mutate(after_placebo = ifelse(week > 2228, 1, 0))

did_basic_placebo = lm(view_time_total_hr ~ premium + after_placebo + premium*after_placebo, data = data_placebo)
summary(did_basic_placebo)