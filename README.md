# languagepredictions
## Generating new predictions of language outcome

*Creators:* Loretta Gasparini, Daisy Shepherd, Melissa Wake, Angela Morgan

*Corresponding author:* Loretta Gasparini (gasparini.lorett@gmail.com)

*Affiliations:* The Murdoch Children's Research Institute & The University of Melbourne

Code originally developed in November 2024

*Last updated:* December 2024

**Background:** Three previous studies (Gasparini et al., 2023; 2024a; 2024b) developed sets of parent-reported predictors that can be asked when children are 2-3 years old that yielded >70% sensitivity and specificity for predicting 11-year language outcomes. A language outcome collected in late childhood allows identification of children with persisting language difficulties, a feature of Language Disorder, rather than children presenting with early language delays, which in many cases resolves without intervention.

**Purpose:** This code allows you to generate predictions about whether 2-3-year-old children are likely to have persisting language difficulties, to aid with recruiting children into research studies.

**Exclusions:** The prediction tool is intended for research purposes only. It is expected to misclassify a large number of children, so is not suitable to screen for or diagnose language disorder.

**Please cite as:**      Gasparini, L., Shepherd, D. A., Wake, M., & Morgan, A. T. (2024). languagepredictions. https://github.com/lottiegasp/languagepredictions

**Further background:**

Gasparini, L., Shepherd, D. A., Lange, K., Wang, J., Verhoef, E., Bavin, E. L., Reilly, S., St. Pourcain, B., Wake, M., & Morgan, A. T. (2024). Combining genetic and behavioral predictors of 11-year language outcome: A multi-cohort study [Preregistration]. Open Science Framework. https://osf.io/mrxdg/ 
		     
Gasparini, L., Shepherd, D.A., Wang, J., Wake, M. & Morgan, A.T. (2024) Identifying early language predictors: A replication of Gasparini et al. (2023) confirming applicability in a general population cohort. International Journal of Language & Communication Disorders, 59, 2352–2366. https://doi.org/10.1111/1460-6984.13086
                     
Gasparini, L., Shepherd, D. A., Bavin, E. L., Eadie, P., Reilly, S., Morgan, A. T., & Wake, M. (2023). Using machine-learning methods to identify early-life predictors of 11-year language outcome. Journal of Child Psychology & Psychiatry, 64(8), 1242-1252. https://doi.org/10.1111/jcpp.13733 

### Instructions:

1. Collect the following survey items from parents of children aged 2 or 3 years old. For example, you could collect the items using REDCap.

	1. Mark the sentence that sounds most like the way your child talks at the moment. If your child is saying sentences even longer or more complicated than the two provided, mark the second one.

			This dolly big
			This dolly big and this dolly little

	Children understand many more words than they can say. We are particularly interested in the words your child SAYS. Please mark the words you have heard your child use. If your child uses a different pronunciation of a word mark the word anyway. This is only a sample of words; your child may know many other words not on this list.

	2. Circle

			Says
			Not yet

	3. Accident

			Says
			Not yet

	4. Forget/forgot

			Says
			Not yet

	5. Either:
		Kangaroo*

			Says
			Not yet

	Or:
		Today**

			Says
			Not yet

*The vocabulary item 'kangaroo' was included in the predictor sets reported in the Gasparini et al. studies.
**The vocabulary item 'today' was not originally included in the predictor sets reported in the Gasparini et al. studies. We have since provided an option to replace 'kangaroo' with 'today' so the predictor set is more applicable internationally.

3. Collate all parents' surveys in a data file

	To simplify data cleaning, it will be helpful to have your data with the following variable names and format or level names. But if you start with different variable names or level names, you can rename them in the R code in step 3.

		Variable names: 		child_id   	dolly     				circle    accident  forget  kangaroo   today   
		Format or level names: 	any	   	this dolly big                        	No   	  No        No      No  	No
 								this dolly big and this dolly little  	Yes       Yes       Yes     Yes		Yes

	Note: For survey items 2-5, the level "No" corresponds to the survey response "Not yet", and the level "Yes" corresponds to the survey response "Says".
		
4. Open the R file "gasparini_newpredictions.R" in RStudio and follow the instructions therein.

5. Refer to the RMarkdown PDF "elvslsac_prediction_results" to see the different prediction cut-offs to suit your goals (e.g. balance sensitivity and specificity, maximise sensitivity etc.)
	
	Contact Loretta Gasparini (gasparini.lorett@gmail.com) if you would like a new cut-off calculated based on a different goal.

6. Use the classifications for your research purposes. For example, if you are recruiting children into an early language intervention study, you can recruit children classified as "Higher chance of LD".
   
	Note: The prediction tool is intended for research purposes only. It is expected to misclassify a large number of children, so is not suitable to screen for or diagnose language disorder.

Please contact Loretta Gasparini (gasparini.lorett@gmail.com) with any questions or feedback.
