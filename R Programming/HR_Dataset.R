# Importing Library
library(tidyverse)
library(dplyr)

# Declaring Variable for designing project . . .
design <- function() {
  color_list <- list(
    link_water = "#D4E6F1",
    biscay = "#154360",
    gossip = "#DAF7A6",
    amber = "#FFC300",
    outrageous_orange = "#FF5733",
    monza = "#C70039"
  )
  
  font_list = list(
    text = "monospaced",
    title = "arial"
  )
  
  element_of = list(
    color = color_list,
    font = font_list,
    data = "C:\\Users\\HP\\OneDrive\\Google Data Analytics\\Project\\HR Analysis\\dataset\\HR_Dataset.csv"
  )
  
  return(element_of)
}

# Initializing our data
hr_data = read.csv(design()$data)



# ********************* 1. Key Performance Indicator ********************* #
kpi <- hr_data %>%
  summarise(Employee_Count = length(Employee_Name), 
            Attrition_Count = sum(AttritionCount),
            Attrition_Rate = round(((Attrition_Count / Employee_Count) * 100), digits = 2),
            Active_Employee = (Employee_Count - Attrition_Count))

kpi_measures <- data.frame(Names = c("Employee Count", "Attrition Count", 
                                     "Attrition Rate", "Active Employee"), 
                          Values = c(1), 
                          Counts = c(kpi$Employee_Count, kpi$Attrition_Count, 
                                     kpi$Attrition_Rate, kpi$Active_Employee))

# Creating a fixed length bar plot with custom value
ggplot(kpi_measures, aes(x = Values, y = Names)) +
  geom_bar(stat = "identity", fill = "white") +  # Fixed length bar with a width of 0.5
  geom_text(aes(label = Counts), hjust = 0.9, size = 11, 
            family = design()$font$title, color = design()$color$biscay,
            fontface = "bold") + 
  scale_x_continuous(breaks = NULL) + 
  theme_minimal() + 
  theme (
    axis.text.y.left = element_text(family = design()$font$text, 
                                    size = 15, hjust = 0, 
                                    color = design()$color$amber), 
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title = element_blank()
  )




# ********************* 2. Attrition by Gender ********************* #
att_gender <- hr_data %>%
  group_by(Sex) %>%
  summarise(Attrition_Count = sum(AttritionCount))

ggplot(data = att_gender, aes(x = Attrition_Count, y = Sex)) + 
  geom_segment(aes(xend = 0, yend = Sex), color = design()$color$gossip, linewidth = 4) + 
  geom_point(color = design()$color$amber, size = 15) + 
  geom_text(aes(label = Attrition_Count), color = design()$color$biscay) + 
  labs (
    title = "Attrition by Gender",
    subtitle = "Numbers of empployee leave the organisation by different gender.",
    x = "Attrition Count",
    y = "Sex"
  ) + 
  theme_minimal() + 
  theme (
    plot.title = element_text(family = design()$font$title, size = 20, 
                              color = design()$color$biscay, face = "bold"),
    plot.subtitle = element_text(family = design()$font$text, size = 15, 
                                 color = design()$color$biscay),
    axis.text = element_text(family = design()$font$text, size = 15, 
                             color = design()$color$biscay, face = "bold"),
    axis.title = element_text(family = design()$font$text, size = 17, 
                              color = design()$color$biscay),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.text.x = element_blank()
  )
  




# ********************* 3. Best Recruiting Source ********************* #
hiring_source <- hr_data %>%
  group_by(RecruitmentSource) %>%
  summarise(Employee_Hire = length(Employee_Name)) %>%
  arrange(desc(Employee_Hire))

ggplot(data = hiring_source, aes(x = Employee_Hire, y = RecruitmentSource)) + 
  geom_bar(stat = "identity", fill = design()$color$amber, width = 0.7) + 
  geom_text(aes(label = Employee_Hire), nudge_x = 5, size = 4, 
            color = design()$color$biscay, fontface = "bold") + 
  labs(
    title = "Employees Hired / Various Recruitment Sources",
    x = "Employees Hired",
    y = "Recruitment Sources"
  ) + 
  theme_minimal() + 
  theme(
    plot.title = element_text(family = design()$font$title, size = 20, hjust = 0.5, 
                              color = design()$color$biscay, face = "bold"),
    axis.text = element_text(family = design()$font$text, size = 10, 
                             color = design()$color$biscay, face = "bold"),
    axis.title = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.text.x = element_blank()
  )




# ********************* 4. Company Diversion ********************* #
# Creating Age Group Extra Column in our HR_Dataset . . .
data <- hr_data %>%
  mutate(AgeGroup = case_when(
    Age > 30 & Age <= 40 ~"31-40",
    Age > 40 & Age <= 50 ~"41-50",
    Age > 50 & Age <= 60 ~ "51-60",
    TRUE ~ "Over 60"
  ))

# Extracting Insights . . .
comp_diversion <- data %>%
  group_by(AgeGroup, Sex) %>%
  summarise(Employee_Count = n())

ggplot(data = comp_diversion, aes(x = "", y = Employee_Count, fill = Sex)) +
  geom_bar(stat = "identity", position = "fill", width = 0.8, 
           color = design()$color$link_water) + 
  geom_text(aes(label = Employee_Count), position = position_fill(vjust = 0.5), 
            size = 4, color = design()$color$link_water) +
  coord_polar(theta = "y") +
  facet_wrap(~AgeGroup) +
  labs(
    title = "Company Diversity",
    subtitle = "Employee Count by Various Age Groups",
    fill = "Sex",
    x = NULL,
    y = NULL
  ) +
  theme_minimal() + 
  theme (
    plot.title = element_text(family = design()$font$title, size = 20, hjust = 0, 
                              color = design()$color$biscay, face = "bold"),
    plot.subtitle = element_text(family = design()$font$text, size = 15, 
                                 color = design()$color$biscay),
    axis.text = element_text(family = design()$font$text, size = 10, 
                             color = design()$color$biscay, face = "bold"),
    axis.text.x = element_blank(),
    panel.grid = element_blank()
  )






# ********************* 5. Work Lie Balance ********************* #
wlb <- hr_data %>%
  group_by(PerformanceScore) %>%
  summarise(Absences = sum(Absences),
            Emp_Satisfaction = sum(EmpSatisfaction),
            Sp_Project = sum(SpecialProjectsCount)) %>%
  arrange(desc(Absences))

wlb_cluster = tidyr::pivot_longer(wlb, cols = c(Absences, Emp_Satisfaction, Sp_Project), 
                                  names_to = "Variable", values_to = "Value")

ggplot(data = wlb_cluster, aes(x = PerformanceScore, y = Value, fill = Variable)) + 
  geom_bar(stat = "identity", position = position_dodge(0.95), 
           color = design()$color$link_water, size = 0.7) + 
  geom_text(aes(label = Value), position = position_dodge(0.9), vjust = -0.7, size = 3) + 
  labs(
    title = "Work Life Balance of Employee",
    x = "Performance Score",
    y = "Variable"
  ) + 
  scale_fill_manual(values = c("Absences" = design()$color$gossip, 
                               "Emp_Satisfaction" = design()$color$amber, 
                               "Sp_Project" = design()$color$biscay)) + 
  theme_minimal() + 
  theme (
    plot.title = element_text(family = design()$font$title, 
                              colour = design()$color$biscay, size = 20),
    axis.title = element_text(family = design()$color$text, 
                              color = design()$color$biscay, size = 13),
    axis.text = element_text(family = design()$color$text, 
                             colour = design()$color$biscay, size = 10),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.y = element_blank()
  )
