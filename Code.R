library(tidyverse)
library(tidytuesdayR)
library(webshot2)
library(gt)
library(gtExtras)
tuesdata <- tidytuesdayR::tt_load(2022, week = 42)
tuesdata$stranger_things_all_dialogue->dialogues
data.frame((dialogues))->dialogues
summary(dialogues)
glimpse(dialogues)

dialogues%>%rowwise()%>%
  mutate(duration=end_time-start_time)%>%
  drop_na(dialogue)%>%
  select(season,episode,dialogue,duration)%>%
  arrange(desc(duration))%>%
  head(10)%>%
  data.frame()

dialogues%>%rowwise()%>%
  mutate(duration=end_time-start_time)%>%
  drop_na(dialogue)%>%
  select(season,episode,dialogue,duration)%>%
  arrange(desc(duration))%>%
  head(8)%>%
  data.frame()->dialogue1

gsub("[^A-Z a-z0-9]", "", dialogue1$dialogue)->dialogue1$dialogue

colnames(dialogue1)<-c("SEASON","EPISODE","DIALOGUE","DURATION (IN SECONDS)")
source_tag <- "Data:TidyTuesday| Design and Analysis: @annapurani93"

dialogue1%>%
  gt()%>%
  tab_options(
    table.background.color = "#051e3e")%>%
  tab_header(title = "Lengthiest Dialogues from Stranger Things")%>%
  tab_source_note(md(html(source_tag)))%>%
  tab_style(
    style = list(
      cell_text(
        align = "right",
        color = "white"
      )
    ), locations = cells_source_notes()
)%>%
  cols_align(
    align = "center",
    columns = c("SEASON","EPISODE","DIALOGUE","DURATION (IN SECONDS)"))%>% 
  tab_style(style = cell_text(weight="bold"),
            locations = cells_column_labels(everything())
  )%>%
  tab_style(
    style = cell_text(align="center"),
    locations = cells_body(
      columns = everything(),
      rows = everything()
    ))%>%
  opt_table_lines("all")%>%
  opt_table_outline()%>%
  opt_row_striping()%>%
  tab_options(
    source_notes.background.color = "#051e3e",
    heading.background.color = "#051e3e",
    column_labels.background.color = "#d1dd93",
    table_body.hlines.color = "#989898",
    table_body.border.top.color = "#989898",
    heading.border.bottom.color = "#989898",
    row_group.border.top.color = "#989898"
  )%>%
  tab_style(
    style = list(
      cell_borders(
        sides = c("top", "bottom"),
        color = "black",
        weight = px(0.2),
        style="dotted"
      ),
      cell_borders(
        sides = c("left", "right"),
        color = "black",
        weight = px(0.2),
        style="dotted"
      )),
    locations = cells_column_labels(
      columns = everything()
    )
  )%>%
  tab_style(
    style = list(
      cell_borders(
        sides = c("top", "bottom"),
        color = "#989898",
        weight = px(1),
        style="dashed"
      ),
      cell_borders(
        sides = c("left", "right"),
        color = "#989898",
        weight = px(1),
        style="dashed"
      )),
    locations = cells_body(
      columns = everything(),
      rows = everything()
    )
  )%>%
  tab_style(
    style = list(
      cell_text(
        color = "white",
        transform = "uppercase"
      )
    ),
    locations = list(
      cells_title(groups = "title")
    )
  )->table

gtsave(table,"tableStrangerThings.png")
