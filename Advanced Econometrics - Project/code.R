library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)
library(plm)
library(stargazer)
library(lmtest)
library(sandwich)

data <- read_excel("data.xlsx")
str(data)


data <- data %>%
  mutate(across(where(is.character), as.factor))
summary(data)


#################################################################

#############       GRAFY A HEZKE VIZUALIZACE       #############

#################################################################


ggplot(data, aes(x = avg_grade)) +
  geom_histogram(aes(y = after_stat(density)),
                 bins = 20,
                 fill = "#4C72B0",
                 color = "white",
                 alpha = 0.85) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

ggplot(data, aes(x = student_rating)) +
  geom_histogram(aes(y = after_stat(density)),
                 bins = 20,
                 fill = "#DD8452",
                 color = "white",
                 alpha = 0.85)  +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

ggplot(data, aes(x = avg_grade, y = student_rating)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Average Grades and Student Evaluations",
    x = "Average grade",
    y = "Student evaluation"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

year_avg <- data %>%
  group_by(year) %>%
  summarise(
    year_avg_grade  = mean(avg_grade, na.rm = TRUE),
    year_avg_rating = mean(student_rating, na.rm = TRUE),
    .groups = "drop"
  )

year_avg_long <- year_avg %>%
  pivot_longer(
    cols = c(year_avg_grade, year_avg_rating),
    names_to = "measure",
    values_to = "value"
  )

ggplot(year_avg_long,
       aes(x = year, y = value, color = measure)) +
  geom_line(linewidth = 1.3) +
  geom_point(size = 2) +
  labs(
    title = "Average Grades and Course Evaluations Over Time",
    x = "Year",
    y = "Average value",
    color = ""
  ) +
  scale_color_manual(
    values = c(
      year_avg_grade  = "#4C72B0",
      year_avg_rating = "#DD8452"
    ),
    labels = c(
      year_avg_grade  = "Average grade",
      year_avg_rating = "Average evaluation"
    )
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

course_avg <- data %>%
  group_by(course) %>%
  summarise(
    avg_grade_course  = mean(avg_grade, na.rm = TRUE),
    avg_rating_course = mean(student_rating, na.rm = TRUE),
    .groups = "drop"
  )

course_order <- course_avg %>%
  arrange(avg_grade_course) %>%
  pull(course)

course_avg_long <- course_avg %>%
  pivot_longer(
    cols = c(avg_grade_course, avg_rating_course),
    names_to = "measure",
    values_to = "value"
  ) %>%
  mutate(course = factor(course, levels = course_order))

ggplot(course_avg_long,
       aes(x = value, y = course, color = measure)) +
  geom_point(size = 2.5, alpha = 0.85) +
  labs(
    title = "Average Grade and Average Rating by Course",
    x = "Value",
    y = "Course",
    color = ""
  ) +
  scale_color_manual(
    values = c(
      avg_grade_course  = "#4C72B0",
      avg_rating_course = "#DD8452"
    ),
    labels = c(
      avg_grade_course  = "Average grade",
      avg_rating_course = "Average rating"
    )
  ) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold")
  )



#################################################################

####################       REALNY ECOX       ####################

#################################################################

pooled_ols1 <- lm(student_rating ~ avg_grade , data = data)

summary(pooled_ols1)

bptest(pooled_ols1)

pooled_ols2 <- lm(student_rating ~ avg_grade + credits + semester + continuation 
                 + n_responses + n_students + pass_rate + mandatory + 
                   mandatory_specialisational, data = data)

summary(pooled_ols2)

bptest(pooled_ols2)

data$time <- interaction(data$year, data$semester, drop = TRUE)

pdata <- pdata.frame(data, index = c("course", "time"))

fe_1 <- plm(
  student_rating ~ avg_grade + credits + continuation +
    n_responses + n_students + pass_rate + mandatory + mandatory_specialisational,
  data = pdata,
  model = "within",
  effect = "individual"
)

summary(fe_1)

bptest(fe_1)

fe_2 <- plm(
  student_rating ~ avg_grade + credits + continuation +
    n_responses + n_students + pass_rate + mandatory + mandatory_specialisational,
  data = pdata,
  model = "within",
  effect = "twoways"
)

summary(fe_2)

bptest(fe_2)

fe_3 <- plm(
  student_rating ~ avg_grade + credits + continuation +
    n_responses + n_students + pass_rate +
    mandatory + mandatory_specialisational |
    credits + continuation +
    n_responses + n_students + pass_rate +
    mandatory + mandatory_specialisational +
    avg_grade_other_years,
  data = pdata,
  model = "within",
  effect = "individual"
)

summary(fe_3)

bptest(fe_3)

fe_4 <- plm(
  student_rating ~ avg_grade + credits + continuation +
    n_responses + n_students + pass_rate +
    mandatory + mandatory_specialisational |
    credits + continuation +
    n_responses + n_students + pass_rate +
    mandatory + mandatory_specialisational +
    avg_grade_other_years,
  data = pdata,
  model = "within",
  effect = "twoway"
)

summary(fe_4)

bptest(fe_4)

se_pooled1 <- sqrt(diag(vcovHC(pooled_ols1, type = "HC1")))
se_pooled2 <- sqrt(diag(vcovHC(pooled_ols2, type = "HC1")))
se_fe1    <- sqrt(diag(vcovHC(fe_1, type = "HC1")))
se_fe2    <- sqrt(diag(vcovHC(fe_2, type = "HC1")))
se_fe3    <- sqrt(diag(vcovHC(fe_3, type = "HC1")))
se_fe4    <- sqrt(diag(vcovHC(fe_4, type = "HC1")))

re_1 <- plm(
  student_rating ~ avg_grade + credits + continuation +
    n_responses + n_students + pass_rate + mandatory + mandatory_specialisational,
  data = pdata,
  model = "random",
  effect = "individual"
)

phtest(fe_1, re_1)

re_3 <- plm(
  student_rating ~ avg_grade + credits + continuation +
    n_responses + n_students + pass_rate +
    mandatory + mandatory_specialisational |
    credits + continuation +
    n_responses + n_students + pass_rate +
    mandatory + mandatory_specialisational +
    avg_grade_other_years,
  data = pdata,
  model = "random",
  effect = "individual"
)

phtest(fe_3, re_3)

se_re1    <- sqrt(diag(vcovHC(re_1, type = "HC1")))
se_re3    <- sqrt(diag(vcovHC(re_3, type = "HC1")))


stargazer(
  pooled_ols1, pooled_ols2, fe_1, fe_2, fe_3, fe_4,
  type = "latex",
  se = list(se_pooled1, se_pooled2, se_fe1, se_fe2, se_fe3, se_fe4)
)

coeftest(re_1, vcov. = function(x) vcovHC(x, type = "HC1"))
coeftest(re_3, vcov. = function(x) vcovHC(x, type = "HC1"))

stargazer(
  re_1, re_3,
  type = "latex",
  se = list(se_re1, se_re3)
)

first_stage_fe <- plm(
  avg_grade ~ avg_grade_other_years + credits + continuation +
    n_responses + n_students + pass_rate + mandatory + mandatory_specialisational,
  data = pdata,
  model = "within",
  effect = "individual"
)

summary(first_stage_fe)

first_stage_fe2 <- plm(
  avg_grade ~ avg_grade_other_years + credits + continuation +
    n_responses + n_students + pass_rate + mandatory + mandatory_specialisational,
  data = pdata,
  model = "within",
  effect = "twoway"
)

summary(first_stage_fe2)

first_stage_re <- plm(
  avg_grade ~ avg_grade_other_years + credits + continuation +
    n_responses + n_students + pass_rate + mandatory + mandatory_specialisational,
  data = pdata,
  model = "random",
  effect = "individual"
)
summary(first_stage_re)
