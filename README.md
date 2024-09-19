# Forecasting and Advanced Business Analysis - R Projects

## 1. **Analysis of Factors Affecting Business Analyst Wages**

### Overview
This project involves a **Multiple Linear Regression** analysis to investigate the factors affecting business analyst wages. The dataset includes factors such as education, experience, tenure, gender, and marital status. We aim to identify which variables significantly influence wages and estimate wage differences based on key factors like gender and tenure.

### Key Findings
- **Education** and **tenure** positively influence wages, with higher levels of education and longer tenures resulting in higher wages.
- **Gender** disparity is evident, as being female has a statistically significant negative impact on wages.
- Interaction between **tenure** and **gender** shows that wage growth with tenure is less pronounced for female employees.

### Code & Usage
#### Libraries
- `corrplot`: For visualizing the correlation matrix.
- `corrgram`: For creating correlation plots.
- `lm()`: Multiple linear regression function in R.
- `anova()`: For comparing models.

#### Key Steps
1. **Correlation and Scatter Plot Analysis**  
   Visualize relationships between variables.
   ```R
   corrplot(cor(data[, c("wage", "educ", "exper", "tenure", "female", "married")]))
    ```
   ![Rplot01](https://github.com/user-attachments/assets/a739ff8c-0ccd-4194-a8a0-46044337d610)
   ```R

   pairs(data[, c("wage", "educ", "exper", "tenure", "female", "married")])
   ```
   ![Rplot](https://github.com/user-attachments/assets/afc7f6c0-733a-436a-a4ab-556209c6b79b)

2. **Multiple Linear Regression**  
   Build regression models to predict wages and determine significant factors.
   ```R
   fit <- lm(wage ~ educ + exper + tenure + female + married, data=data)
   fit2 <- lm(wage ~ educ + tenure + female, data=data)
   ```
3. **Interaction Terms**  
   Investigate if the effect of **tenure** on wages differs by gender.
   ```R
   fit5 <- lm(wage ~ tenure * female, data=data)
   ```

4. **Predict Expected Wage**  
   Estimate wages using the reduced model.
   ```R
   predict(fit2, list(educ=16, tenure=2, female=0))
   ```

### Results
- **Adjusted R-squared**: 0.3621 for the initial model, explaining 36.21% of the variation in wages.
- **Interaction effect**: Female employees see less wage growth from tenure compared to their male counterparts.

---

## 2. **Topic Modeling of Amazon Mobile Phone Reviews**

### Overview
This project uses **Latent Dirichlet Allocation (LDA)** to perform topic modeling on Amazon mobile phone reviews. The goal is to identify key themes in **positive** and **negative** customer feedback by analyzing text data from a sample of 5,000 reviews.

### Key Findings
- **Positive Reviews** focus on factors like **camera quality**, **battery life**, and **value for money**.
- **Negative Reviews** highlight issues with **battery**, **camera problems**, and **software performance**.

### Methodology
#### Libraries
- `tm`: Text mining and document-term matrix creation.
- `topicmodels`: For performing topic modeling using LDA.
- `ldatuning`: Helps identify the optimal number of topics.
- `wordcloud`: For visualizing common words in reviews.

#### Key Steps
1. **Data Preprocessing**  
   Clean text data by removing punctuation, stopwords, and performing lemmatization.
   ```R
   pos_dtmdocs <- DocumentTermMatrix(pos_docs, control = list(...))
   neg_dtmdocs <- DocumentTermMatrix(neg_docs, control = list(...))
   ```

2. **Word Cloud Analysis**  
   Generate word clouds to visualize frequently occurring terms in reviews.
   ```R
   wordcloud(pos_words[1:100], pos_frequency[1:100], ...)
   ```
   ![Pos_cloud_words](https://github.com/user-attachments/assets/6a67706d-6279-4de5-b23d-aba915ce8313)

3. **Determine Number of Topics**  
   Use `ldatuning` to evaluate metrics like Griffiths2004, CaoJuan2009, and Arun2010 for topic optimization.
   ```R
   pos_result <- FindTopicsNumber(pos_dtm.new, ...)
   FindTopicsNumber_plot(pos_result)
   ```
   ![Pos_LDA](https://github.com/user-attachments/assets/91254946-5df3-43fa-a66c-9cf27421f8b4)

4. **LDA Topic Modeling**  
   Perform LDA with Gibbs sampling and visualize the results.
   ```R
   pos_ldaOut <- LDA(pos_dtmdocs, 7, method="Gibbs", control=list(...))
   ```
   ![Pos_count_plot](https://github.com/user-attachments/assets/ced282ab-1bca-406f-9fe2-418377f4be28)

### Results
- **Top Positive Topics**: Camera quality, battery life, and value for money.
- **Top Negative Topics**: Battery issues, camera problems, and software glitches.

### Visualizations
- Word clouds for positive and negative reviews provide an intuitive representation of key factors.
- Count plots for LDA topics display the distribution of topics across reviews.

---

## Installation & Setup

To replicate the analysis:

1. Clone the repository:
   ```bash
   git clone https://github.com/username/repository-name.git
   ```
2. Install required R packages:
   ```R
   install.packages(c("tm", "corrplot", "corrgram", "topicmodels", "ldatuning", "wordcloud"))
   ```

3. Load the dataset for the **Wage Analysis** and **Mobile Reviews**:
   ```R
   data <- read.csv("B3.csv")  # For wage analysis
   reviews_data <- fromJSON("https://query.data.world/s/4ria2tfww73wmhfzke5z2w4zlez2re")  # For reviews analysis
   ```

4. Run the analysis scripts in the provided R files.

## License
This project is licensed under the MIT License.
