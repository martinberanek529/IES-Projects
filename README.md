# IES Study Projects

This repository contains a collection of projects completed during my studies at the Institute of Economic Studies, Faculty of Social Sciences, Charles University.

The main purpose of this repository is to store selected empirical, econometric, and data analysis projects in one place. Each project is organized in a separate folder named after the course for which it was prepared.

## Repository structure

Each course project has its own folder. Inside each folder, the structure may include:

- source code used for data cleaning, modelling, estimation, forecasting, or visualization
- input data or data-related files, where possible
- generated figures, tables, images, or other outputs
- the final project report, usually in PDF format (or in the case of the Financial Econometrics I project, the final report is stored as an HTML file generated from the analytical workflow)

## Projects included

### Advanced Econometrics (WS of 2025/2026)

**Do better grades improve student evaluation of courses?**

This project studies the relationship between students' average grades and course evaluations at the Institute of Economic Studies. The motivation is to examine whether better grades are associated with better course evaluations, which relates to the broader discussion about grading leniency and possible bias in student evaluations of teaching.

The project uses panel data on IES courses and semesters from 2021 to 2024. The dataset contains course-level observations, including average grades, student ratings, number of students, number of survey responses, credits, pass rates, semester information, and indicators for mandatory courses.

The empirical analysis applies several econometric methods, including pooled OLS, fixed effects, random effects, and instrumental variable approaches. The main idea is to separate the simple correlation between grades and evaluations from unobserved course-specific heterogeneity.

My contribution: I worked on the coding and empirical analysis for this project. I prepared and ran the econometric models and contributed to interpreting the results, but I did not write the final report itself.

### Data Science with R I (WS of 2025/2026)

**Predicting speaker performance in debates**

This project analyzes individual and team performance in competitive debating. The dataset contains real-world debate tournament data covering multiple seasons and many speaker-level observations. It includes information on speaker scores, team composition, debate motions, tournament stages, sides in debates, experience, and teammate performance.

The project combines econometric methods with machine learning. The econometric part focuses on explaining individual speaker performance using pooled OLS, fixed effects models, and dynamic panel data methods. The machine learning part uses models such as XGBoost to predict speaker-level performance, team-level outcomes, and to test whether debate motion text contains systematic predictive information about side advantage.

The main findings suggest that teammate quality is an important predictor of speaker performance, while there is no strong evidence of a gender gap in performance. Machine learning models perform better for team-level prediction than simple linear econometric models.

My contribution: I did not work on the coding part of this project. My main contribution was writing the majority of the final report and helping present and interpret the results clearly.

### Financial Econometrics I (SS of 2025/2026)

**Volatility modelling and forecasting**

This project focuses on financial volatility forecasting. The analysis uses data for Asset 29, including daily returns and realized measures such as realized volatility, positive and negative realized volatility components, realized skewness, and realized kurtosis.

The project compares several volatility forecasting approaches, including HAR-type models and GARCH-type models. The analysis evaluates both expanding-window and rolling-window out-of-sample forecasts. Model performance is compared using forecast errors, loss functions, Diebold-Mariano tests, and Mincer-Zarnowitz regressions.

The results show that HAR-family models, especially the model using realized skewness and realized kurtosis, performed better than traditional GARCH specifications in this forecasting exercise. The project highlights the usefulness of high-frequency realized volatility measures for forecasting future volatility.

My contribution: I completed Parts 1 and 2 of this project. These parts included the initial data inspection, descriptive analysis, visualization, and the early modelling work using Realized Volatility models and GARCH family models.
