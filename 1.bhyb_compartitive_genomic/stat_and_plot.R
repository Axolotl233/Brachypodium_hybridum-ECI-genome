rm(list=ls())

library(tidyverse)
library(RColorBrewer)
library(viridis)
library(gg.gap)
library(patchwork)
library(ggridges)
library(cowplot)
library(geneRal)
library(ggpubr)
library(ggrepel)
library(ggstatsplot)
library(pheatmap)

## ks
rm(list = ls())
densFindPeak <- function(x){
  td <- density(x)
  maxDens <- which.max(td$y)
  list(x=td$x[maxDens],y=td$y[maxDens])
}

data1 <- read_table("z.extract.ks.txt")
colnames(data1) <- c("Species","NG86","YN00")
compare_list = unique(data1$Species)
data1_res <- data.frame(Species="",
                       NG86_peak_x=0,
                       NG86_peak_y=0,
                       YN00_peak_x=0,
                       YN00_peak_y=0)

for(i in 1:length(compare_list)){
  tmp_data <- data1 %>% filter (Species == compare_list[i])
  tmp_1 = as.data.frame(tmp_data)[,2]
  tmp_2 = as.data.frame(tmp_data)[,3]
  res_1 <- densFindPeak(tmp_1)
  res_2 <- densFindPeak(tmp_2)
  data1_res[i,] = c(compare_list[i],res_1$x,res_1$y,res_2$x,res_2$y)
}
data1_res$NG86_peak_x <- as.numeric(data1_res$NG86_peak_x)
data1_res$NG86_peak_y <- as.numeric(data1_res$NG86_peak_y)
data1_res$YN00_peak_x <- as.numeric(data1_res$YN00_peak_x)
data1_res$YN00_peak_y <- as.numeric(data1_res$YN00_peak_y)

data2 <- read_table("z.extract.ks.block.txt")
colnames(data2) <- c("Species","median","average")
compare_list = unique(data2$Species)
data2_res <- data.frame(Species="",
                        ave_peak_x=0,
                        ave_peak_y=0,
                        median_peak_x=0,
                        median_peak_y=0
                        )
for(i in 1:length(compare_list)){
  tmp_data <- data2 %>% filter (Species == compare_list[i])
  tmp_1 = as.data.frame(tmp_data)[,2]
  tmp_2 = as.data.frame(tmp_data)[,3]
  res_1 <- densFindPeak(tmp_1)
  res_2 <- densFindPeak(tmp_2)
  data2_res[i,] = c(compare_list[i],res_1$x,res_1$y,res_2$x,res_2$y)
}
data2_res$ave_peak_x <- as.numeric(data2_res$ave_peak_x)
data2_res$ave_peak_y <- as.numeric(data2_res$ave_peak_y)
data2_res$median_peak_x <- as.numeric(data2_res$median_peak_x)
data2_res$median_peak_y <- as.numeric(data2_res$median_peak_y)

ggplot(data1)+
  geom_density_ridges_gradient(aes(x = YN00, y = Species, fill = Species,color=Species),
                               scale = 2, rel_min_height = 0.00,size = 0.3,alpha=0.2)+
  scale_x_continuous(
    limits = c(-0.005,0.2)
  )

ggplot(data2)+
  geom_density_ridges_gradient(aes(x = median, y = Species, fill = Species,color=Species),
                               scale = 2, rel_min_height = 0.00,size = 0.3,alpha=0.2)+
  scale_x_continuous(
    limits = c(-0.01,0.2)
  )
compare_list
#"BhSEC-BstaEC","BhSabr113-BstaABR114"
#"BhSEC-BhSabr113","BstaEC-BstaABR114"
s_list <- c("BhSEC-BhSabr113","BstaEC-BstaABR114",
            "BhSabr113-BstaEC","BhSEC-BstaABR114",
            "BhSEC-BstaEC","BhSabr113-BstaABR114")
data3 <- data1 %>% filter(Species %in% c("BhSEC-BhSabr113","BstaEC-BstaABR114",
                                           "BhSabr113-BstaEC","BhSEC-BstaABR114",
                                         "BhSEC-BstaEC","BhSabr113-BstaABR114")) %>%
  filter(YN00 < 0.01) %>% filter (YN00 != 0)

data3_res <- data.frame(Species="",
                        NG86_peak_x=0,
                        NG86_peak_y=0,
                        YN00_peak_x=0,
                        YN00_peak_y=0)

for(i in 1:length(compare_list)){
  tmp_data <- data3 %>% filter (Species == s_list[i])
  tmp_1 = as.data.frame(tmp_data)[,2]
  tmp_2 = as.data.frame(tmp_data)[,3]
  res_1 <- densFindPeak(tmp_1)
  res_2 <- densFindPeak(tmp_2)
  data3_res[i,] = c(s_list[i],res_1$x,res_1$y,res_2$x,res_2$y)
}
data3_res$ave_peak_x <- as.numeric(data3_res$ave_peak_x)
data3_res$ave_peak_y <- as.numeric(data3_res$ave_peak_y)
data3_res$median_peak_x <- as.numeric(data3_res$median_peak_x)
data3_res$median_peak_y <- as.numeric(data3_res$median_peak_y)

data3_1 <- data1 %>% filter(Species %in% c("BhSEC-BhSabr113","BstaEC-BstaABR114",
                                         "BhSEC-BstaEC","BhSabr113-BstaABR114",
                                         "BhSEC-BhS26")) %>%
  filter(YN00 < 0.1) %>% filter (YN00 != 0)
data3_1$Species <- factor(data3_1$Species,levels = rev(c("BhSEC-BhSabr113","BstaEC-BstaABR114",
                                                     "BhSEC-BstaEC","BhSabr113-BstaABR114","BhSEC-BhS26")))
ggplot(data3_1)+
  geom_density_ridges(aes(x = YN00, y = Species, fill = Species),color=NA,
                               scale = 0.9, rel_min_height = 0.0,size = 0.4,alpha = 0.8)+
  scale_x_continuous(
    limits = c(-0.01,0.08)
  )+
  theme_cowplot()+
  theme(legend.position = "none")+
  scale_fill_manual(
    values = c("#fcbba1","#fe9929","#ec7014","#fb6a4a","#ef3b2c"),
  )
  #scale_color_manual(
  #  values = c("#fcbba1","#fc9272","#fb6a4a","#ef3b2c","#cb181d")
  #)

ggsave("KS.s.pdf",width = 8,height = 3)
data3_2 <- data1 %>% filter(Species %in% c("BhDEC-BhDabr113","Bd11-Bd21",
                                           "BhDEC-Bd11","BhDabr113-Bd21",
                                           "BhDEC-BhD26")) %>%
  filter(YN00 < 0.1) %>% filter (YN00 != 0)
data3_2$Species <- factor(data3_2$Species,levels = rev(c("BhDEC-BhDabr113","Bd11-Bd21",
                                                         "BhDEC-Bd11","BhDabr113-Bd21",
                                                         "BhDEC-BhD26")))
ggplot(data3_2)+
  geom_density_ridges(aes(x = YN00, y = Species, fill = Species),color=NA,
                      scale = 0.9, rel_min_height = 0.0,size = 0.4,alpha = 0.8)+
  scale_x_continuous(
    limits = c(-0.01,0.08)
  )+
  theme_cowplot()+
  theme(legend.position = "none")+
  scale_fill_manual(
    values = c("#99d8c9","#9ebcda","#8c96c6","#6baed6","#4292c6"),
  )
ggsave("KS.d.pdf",width = 8,height = 3)

data3_3 <- data1 %>% filter(Species %in% c("Bd21-BstaABR114","Bd11-BstaEC",
                                           "BhDEC-BhSEC","BhDabr113-BhSabr113",
                                           "BhD26-BhS26")) %>% filter (YN00 != 0)
data3_3$Species <- factor(data3_3$Species,levels = rev(c("BhDEC-BhSEC","BhDabr113-BhSabr113",
                                                         "Bd11-BstaEC","Bd21-BstaABR114",
                                                         "BhD26-BhS26")))
ggplot(data3_3)+
  geom_density_ridges(aes(x = YN00, y = Species, fill = Species),color=NA,
                      scale = 0.9, rel_min_height = 0.0,size = 0.4,alpha = 0.8)+
  scale_x_continuous(
    limits = c(-0.05,0.4)
  )+
  theme_cowplot()+
  theme(legend.position = "none")+
  scale_fill_manual(
    values = c("#d9d9d9","#bdbdbd","#969696","#737373","#525252"),
  )
ggsave("KS.sub.pdf",width = 8,height = 3)

data3_4 <- data1 %>% filter(Species %in% c("BhDEC-BhD26","BhSEC-BhS26","BhDEC-BhSEC","BhDabr113-BhSabr113",
                                           "Bd11-BstaEC")) %>% filter (YN00 != 0)
data3_4$Species <- factor(data3_4$Species,levels = rev(c("BhDEC-BhD26","BhSEC-BhS26","BhDEC-BhSEC","BhDabr113-BhSabr113",
                                                         "Bd11-BstaEC")))
ggplot(data3_4)+
  geom_density_ridges(aes(x = YN00, y = Species, fill = Species),color=NA,
                      scale = 0.9, rel_min_height = 0.0,size = 0.4,alpha = 0.8)+
  scale_x_continuous(
    limits = c(-0.05,0.4),
    breaks = seq(-0.05,0.4,0.05)
  )+
  theme_cowplot()+
  theme(legend.position = "none")+
  scale_fill_manual(
    values = c("#969696","#737373","#525252","#fcbba1","#99d8c9"),
  )
ggsave("KS.d-anc.pdf",width = 8,height = 3)
#scale_color_manual(

#  values = c("#fcbba1","#fc9272","#fb6a4a","#ef3b2c","#cb181d")
#)

ggplot(data3_4)+
  geom_density(aes(x = YN00,color=Species))+
  theme_cowplot()+
  scale_x_continuous(
    limits = c(-0.05,0.4),
    breaks = seq(-0.05,0.4,0.05)
  )

t1 <- matrix(c(14845,12912,11298,13242),nrow = 2)
chisq.test(t1)
pheatmap(t1,
         cellwidth = 50, cellheight = 50, 
         color = colorRampPalette(colors = c("blue","white","red"))(200),
         display_numbers = TRUE,
         border_color = "white"
         )

t2 <- matrix(c(13418,8998,11020,7770),nrow = 2)
pheatmap(t2,
         cellwidth = 50, cellheight = 50, 
         color = colorRampPalette(colors = c("blue","white","red"))(200),
         display_numbers = TRUE,
         border_color = "white"
)
chisq.test(t2)
c1 <- c("BhDEC-BhDabr113","Bd11-Bd21",
        "BhDEC-Bd11","BhDabr113-Bd21")
data4_1 <- data1 %>% filter(Species %in% c(c1)) %>% filter (YN00 != 0) %>% filter (YN00 < 0.08)
data4_res <- data.frame(Species="",
                        NG86_peak_x=0,
                        NG86_peak_y=0,
                        YN00_peak_x=0,
                        YN00_peak_y=0)

for(i in 1:length(c1)){
  tmp_data <- data4_1 %>% filter (Species == c1[i])
  tmp_1 = as.data.frame(tmp_data)[,2]
  tmp_2 = as.data.frame(tmp_data)[,3]
  res_1 <- densFindPeak(tmp_1)
  res_2 <- densFindPeak(tmp_2)
  data4_res[i,] = c(c1[i],res_1$x,res_1$y,res_2$x,res_2$y)
}
data4_res$NG86_peak_x <- as.numeric(data4_res$NG86_peak_x)
data4_res$NG86_peak_y <- as.numeric(data4_res$NG86_peak_y)
data4_res$YN00_peak_x <- as.numeric(data4_res$YN00_peak_x)
data4_res$YN00_peak_y <- as.numeric(data4_res$YN00_peak_y)
mean(data4_res$YN00_peak_x)

data_sp <- read_table("sp_color1.txt",col_names = F)
data <- read.table("2.gc.txt")

colnames(data) <- c("species","GC","subgenome")
data$species <- factor(data$species,levels = data_sp$X1)
ggplot(data)+
  geom_density(aes(x=GC,color=species))+
  scale_x_continuous(limits = c(35,60))+
  scale_color_manual(values = data_sp$X2)+
  theme_bw()+
  theme(
    panel.grid = element_blank()
  )+facet_grid(subgenome~.)

data_sp2 <- read_table("sp_colo2.txt",col_names = F)
data <- read.table("0.repeat.stat.fix.tab")
identical(sort(unique(data$V4)),sort(data_sp2$X1))
colnames(data) <- c("tmp1","pos","cov","species","genome","pair")
data$genome <- factor(data$genome,levels = sort(unique(data$genome)))
data$species <- factor(data$species,levels = data_sp2$X1)

ggplot(data,aes(x=species,y=cov))+
  geom_boxplot(aes(color=species),outlier.shape=NA)+
  geom_line(aes(group=pair),color="grey80",linetype="dashed")+
  geom_point(aes(color=species),size=1.5)+
  facet_grid(pos~genome,scales = "free")+
  theme_bw()+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 90,vjust = 0.5,hjust = 1),
    legend.position = "none"
  )+
  scale_color_manual(values = data_sp2$X2)

data_d1 <- data %>% filter(pos == "down",species == "Bd11")
data_d2 <- data %>% filter(pos == "down",species == "BhDEC")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "down",species == "Bd21")
data_d2 <- data %>% filter(pos == "down",species == "BhDABR113")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "down",species == "Bd21")
data_d2 <- data %>% filter(pos == "down",species == "BhD26")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "up",species == "Bd11")
data_d2 <- data %>% filter(pos == "up",species == "BhDEC")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "up",species == "Bd21")
data_d2 <- data %>% filter(pos == "up",species == "BhDABR113")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "up",species == "Bd21")
data_d2 <- data %>% filter(pos == "up",species == "BhD26")  

data_d1 <- data %>% filter(pos == "gene",species == "Bd11")
data_d2 <- data %>% filter(pos == "gene",species == "BhDEC")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "gene",species == "Bd21")
data_d2 <- data %>% filter(pos == "gene",species == "BhDABR113")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "gene",species == "Bd21")
data_d2 <- data %>% filter(pos == "gene",species == "BhD26")  
wilcox.test(data_d1$cov,data_d2$cov,paired = T)

data_d1 <- data %>% filter(pos == "down",species == "BstaEC")
data_d2 <- data %>% filter(pos == "down",species == "BhSEC")  
wilcox.test(data_d1$cov,data_d2$cov,paired = T)

data_d1 <- data %>% filter(pos == "down",species == "BstaABR114")
data_d2 <- data %>% filter(pos == "down",species == "BhSABR113")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "down",species == "BstaABR114")
data_d2 <- data %>% filter(pos == "down",species == "BhS26")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "gene",species == "BstaEC")
data_d2 <- data %>% filter(pos == "gene",species == "BhSEC")  
wilcox.test(data_d1$cov,data_d2$cov,paired = T)

data_d1 <- data %>% filter(pos == "gene",species == "BstaABR114")
data_d2 <- data %>% filter(pos == "gene",species == "BhSABR113")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "gene",species == "BstaABR114")
data_d2 <- data %>% filter(pos == "gene",species == "BhS26")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "up",species == "BstaEC")
data_d2 <- data %>% filter(pos == "up",species == "BhSEC")  
wilcox.test(data_d1$cov,data_d2$cov,paired = T)

data_d1 <- data %>% filter(pos == "up",species == "BstaABR114")
data_d2 <- data %>% filter(pos == "up",species == "BhSABR113")  
wilcox.test(data_d1$cov,data_d2$cov)

data_d1 <- data %>% filter(pos == "up",species == "BstaABR114")
data_d2 <- data %>% filter(pos == "up",species == "BhS26")  
wilcox.test(data_d1$cov,data_d2$cov)

data_sp <- read_table("sp_colo1.txt",col_names = F)
data <- read.table("all.txt")  
colnames(data) <- c("Type","InsertTime","Species","Genome")
data$Species <- factor(data$Species,levels = data_sp$X1)
data$Genome <- factor(data$Genome,levels = c("S","D"))
ggplot(data)+
  #geom_histogram(aes(x=InsertTime,fill=Species,color=Species),alpha=0.1,bins=40,
  #               position = "identity",boundary=0)+
  geom_density(aes(x=InsertTime,fill=Species,color=Species),alpha = 0.1)+
  theme_bw()+
  theme(panel.grid = element_blank())+
  scale_fill_manual(
    values = data_sp$X2
  )+
  scale_color_manual(
    values = data_sp$X2
  )+
  facet_grid(Type~Genome)

data <- read_table("hse.new.txt",col_names = F) %>% select(X1,X3,X6,X8,X9)
colnames(data) <- c("sample","del","dup","ref","group")
tmp_symnum <- list(cutpoints = c(0, 0.01, 0.05, 1), symbols = c("**", "*", "ns"))

data_1 <- data %>% filter(group == "Eastern")
p1 <- ggplot(data_1,aes(x=ref,y=del)) +
  geom_boxplot(aes(color=ref),outlier.shape=NA)+
  geom_line(aes(group=sample),color="grey70",linetype="dashed")+
  geom_point(aes(color=ref),size=1.5)+
  #facet_grid(pos~.,scales = "free")+
  scale_color_manual(values = c("#85D0F2","#0E5B7C"))+
  labs(x = "", y = "",title = "Eastern-Deletion")+
  stat_compare_means(comparisons =  list(c("Bd1-1-BstaECI","Bd21-ABR114")),
                     method = "wilcox.test", label = "p.signif", symnum.args = tmp_symnum,paired = T
  )+
  theme_bw()+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle=90),
    legend.position = "none"
  )+
  scale_y_continuous(
    limits = c(115,195),
    breaks = seq(115,195,10)
  )
p2 <- ggplot(data_1,aes(x=ref,y=dup)) +
  geom_boxplot(aes(color=ref),outlier.shape=NA)+
  geom_line(aes(group=sample),color="grey70",linetype="dashed")+
  geom_point(aes(color=ref),size=1.5)+
  #facet_grid(pos~.,scales = "free")+
  scale_color_manual(values = c("#F5AB78","#8F4423"))+
  labs(x = "", y = "",title = "Eastern-Duplication")+
  stat_compare_means(comparisons =  list(c("Bd1-1-BstaECI","Bd21-ABR114")),
                     method = "wilcox.test", label = "p.signif", symnum.args = tmp_symnum,paired = T
  )+
  theme_bw()+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle=90),
    legend.position = "none"
  )+
  scale_y_continuous(
    limits = c(5,45),
    breaks = seq(5,45,10)
  )

data_2 <- data %>% filter(group == "Western")
p3 <- ggplot(data_2,aes(x=ref,y=del)) +
  geom_boxplot(aes(color=ref),outlier.shape=NA)+
  geom_line(aes(group=sample),color="grey70",linetype="dashed")+
  geom_point(aes(color=ref),size=1.5)+
  #facet_grid(pos~.,scales = "free")+
  scale_color_manual(values = c("#85D0F2","#0E5B7C"))+
  labs(x = "", y = "",title = "Western-Deletion")+
  stat_compare_means(comparisons =  list(c("Bd1-1-BstaECI","Bd21-ABR114")),
                     method = "wilcox.test", label = "p.signif", symnum.args = tmp_symnum,paired = T
  )+
  theme_bw()+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle=90),
    legend.position = "none"
  )+
  scale_y_continuous(
    limits = c(115,195),
    breaks = seq(115,195,10)
  )
p4 <- ggplot(data_2,aes(x=ref,y=dup)) +
  geom_boxplot(aes(color=ref),outlier.shape=NA)+
  geom_line(aes(group=sample),color="grey70",linetype="dashed")+
  geom_point(aes(color=ref),size=1.5)+
  #facet_grid(pos~.,scales = "free")+
  scale_color_manual(values = c("#F5AB78","#8F4423"))+
  labs(x = "", y = "",title = "Western-Duplication")+
  stat_compare_means(comparisons =  list(c("Bd1-1-BstaECI","Bd21-ABR114")),
                     method = "wilcox.test", label = "p.signif", symnum.args = tmp_symnum,paired = T
  )+
  theme_bw()+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle=90),
    legend.position = "none"
  )+
  scale_y_continuous(
    limits = c(5,45),
    breaks = seq(5,45,10)
  )

data_3 <- data %>% filter(group == "D-ancestral")
p5 <- ggplot(data_3,aes(x=ref,y=del)) +
  geom_line(aes(group=sample),color="grey70",linetype="dashed")+
  geom_point(aes(color=ref),size=1.5)+
  #facet_grid(pos~.,scales = "free")+
  scale_color_manual(values = c("#85D0F2","#0E5B7C"))+
  labs(x = "", y = "",title = "Western-Deletion")+
  theme_bw()+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle=90),
    legend.position = "none"
  )
p6 <- ggplot(data_3,aes(x=ref,y=dup)) +
  geom_line(aes(group=sample),color="grey70",linetype="dashed")+
  geom_point(aes(color=ref),size=1.5)+
  #facet_grid(pos~.,scales = "free")+
  scale_color_manual(values = c("#F5AB78","#8F4423"))+
  labs(x = "", y = "",title = "Western-Duplication")+
  theme_bw()+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle=90),
    legend.position = "none"
  )
plot_grid(p5,p6)
plot_grid(p1,p2,p3,p4,nrow = 1)
tmp_a <- data_1[data_1$ref == "Bd21-ABR114",]
tmp_b <- data_1[data_1$ref == "Bd1-1-BstaECI",]
wilcox.test(tmp_a$del,tmp_b$del,paired = T)
wilcox.test(tmp_a$dup,tmp_b$dup,paired = T)

tmp_a <- data_2[data_2$ref == "Bd21-ABR114",]
tmp_b <- data_2[data_2$ref == "Bd1-1-BstaECI",]
wilcox.test(tmp_a$del,tmp_b$del,paired = T,alternative = "less")
wilcox.test(tmp_a$dup,tmp_b$dup,paired = T)

## gene family
rm(list=ls())
data <- as.data.frame(read.table("03.OrthoTypeHistgram.pl.plot",header = T))
data <- within(data,{
  ID<-factor(ID,levels=rev(c("Bd11","Bd21","BhDABR113","BhDBd26","BhDEC","BhSABR113","BhSBd26","BhSEC","BstaABR114","BstaEC","Osat")))
  type <- factor(type,levels = c("Single_copy_orthologs","Multiple_copy_orthologs","Unique_paralogs","Other_orthologs","Unclustered_genes"))
})
ggplot(data)+
geom_bar(aes(x=ID,y=num,fill=factor(type),group = factor(1)),stat='identity', position='stack',width = 0.7)+
  theme_classic()+
  coord_flip()+
  scale_fill_manual(
    values = rev(c("#bfd4cb","#d9a79c","#b75b8b","#5483a7","#575b8c"))
  )+
  scale_y_continuous(breaks = seq(0,50000,10000),)+
  xlab("Genome")+
  ylab("Gene_count")+
  theme_bw()+
  theme(legend.title = element_blank(),panel.grid.minor = element_blank(),panel.grid.major = element_blank())

data=read.table("2.Pop.PCA.evec.ggplot2",header=T);
my_color = c("#99d8c9","#F39800","#6baed6","#E83828","#4363d8")
ggplot(data)+
  geom_point(aes(PC1,PC2,color=group,shape = group),alpha=0.8,size=4) + 
  scale_color_manual(values = my_color) +
  theme_bw()+
  theme(
    panel.grid = element_blank(),
    legend.position = "none"
  )+
  labs(x="PC1 (13.37%)",y="PC2 (4.684%)", title = "Individuals PCA")+
  stat_ellipse(aes(x=PC1,y=PC2,color=group,fill=NULL),
                   geom = "polygon",alpha=0.5)

data <- read.table("z.pi.txt") %>% select(V1,V5,V6)
colnames(data) <- c("Pop","Pi","Snp_num")
data <- data %>%
  filter(Snp_num > 10)

data$Pop <- factor(data$Pop,levels=c("Bhyb-East","Bhyb-West","Bsta-East"))
data$new_Pi <- (data$Pi*data$Snp_num)/10000
ggplot(data,aes(x=Pop,y=new_Pi)) +
  geom_violin(aes(fill = Pop),trim=FALSE, color = "white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  stat_compare_means(comparisons =  list(c("Bhyb-East","Bhyb-West"),c("Bhyb-East","Bsta-East"),c("Bhyb-West","Bsta-East")),
                     method = "wilcox.test", label = "p.signif", 
                     symnum.args = tmp_symnum)+
  theme_bw()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = c("#E0901E","#557DA6","#CF3C2A")
  )
data <- read.table("z.fst.txt") %>% select(V1,V2,V6,V7,V8)
colnames(data) <- c("Pop1","Pop2","Fst","Snp_num","Group")
data <- data %>%
  filter(Snp_num > 10)

data[which(data$Fst < 0),3] = 0
data %>% filter(Fst > 0) %>% group_by(Group) %>% summarise(median(Fst))

t <- unique(data$Group)
data$Group <- factor(data$Group,levels = c(t[1],t[3],t[2]))
ggplot(data,aes(x=Group,y=Fst)) +
  geom_violin(aes(fill = Group),trim=T, color = "white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  stat_compare_means(comparisons =  list(c(t[1],t[2]),c(t[2],t[3]),c(t[1],t[3])),
                     method = "wilcox.test", label = "p.signif", 
                     symnum.args = tmp_symnum)+
  theme_bw()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = c("#c9b385","#9dabdd","#d6837a")
  )+
  scale_y_continuous(
    breaks = seq(0,1,0.2)
    #limits = c(0,1)
  )

sample_seq2 <- c("Bhyb-118-5","Bhyb-26","Bhyb-ABR105","Bhyb-118-8","Bhyb-123","Bhyb-127",
                 "Bhyb-30","Bhyb-ABR112","Bhyb-ABR113","Bhyb-BdTR4f","Bhyb-Isk-P1","Bsta-TE43",
                 "Bsta-Cef2","Bsta-ABR114","Bhyb-IBD189","Bhyb-Is-151","Bhyb-Is-293","Bhyb-ABR117",
                 "Bhyb-50","Bhyb-Is-143","Bhyb-Is-7","Bhyb-Is-142","Bhyb-ABR100","Bhyb-17","Bhyb-Adi-P1",
                 "Bhyb-Bal-P1","Bhyb-BdTR6g","Bhyb-AS-1","Bhyb-AS-10","Bhyb-AS-11","Bhyb-AS-12","Bhyb-AS-2",
                 "Bhyb-AS-5","Bhyb-AS-6","Bhyb-IBD107","Bhyb-Is-146","Bhyb-51","Bsta-ES-13",
                 "Bsta-ES-15","Bsta-ES-16","A2A-2-1","A2A-2-2","A2A-4-1","Bsta-Is-135","Bsta-Is-223",
                 "Bsta-Is-256","Bsta-Is-271","Bsta-Is-1")
data2 <- read.table("Pop.extract.2.result.ggplot",header = T)
data2$id <- factor(data2$id,levels = sample_seq2)
ggplot(data2,aes(x=id,y=percent))+
  geom_bar(stat="identity",aes(fill=k),width=1)+
  theme_cowplot()+
  theme(axis.text.x=element_text(angle = 90, hjust = 1,vjust = 0.5),
        panel.grid = element_blank()
        )+
  scale_fill_manual(
    values = c("#6baed6","#CC6A6A")
  )
ggsave("str.2.pdf",width = 12,height = 3)

data3 <- read.table("Pop.extract.3.result.ggplot",header = T)
data3$id <- factor(data3$id,levels = sample_seq2)
ggplot(data3,aes(x=id,y=percent))+
  geom_bar(stat="identity",aes(fill=k),width=1)+
  theme_cowplot()+
  theme(axis.text.x=element_text(angle = 90, hjust = 1,vjust = 0.5),
        panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = c("#6baed6","#F2B686","#CC6A6A")
  )
ggsave("str.3.pdf",width = 12,height = 3)

data4 <- read.table("Pop.extract.4.result.ggplot",header = T)
data4$id <- factor(data4$id,levels = sample_seq2)
ggplot(data4,aes(x=id,y=percent))+
  geom_bar(stat="identity",aes(fill=k),width=1)+
  theme_cowplot()+
  theme(axis.text.x=element_text(angle = 90, hjust = 1,vjust = 0.5),
        panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = c("#F2B686","#99d8c9","#6baed6","#CC6A6A")
  )
ggsave("str.4.pdf",width = 12,height = 3)

data5 <- read.table("Pop.extract.5.result.ggplot",header = T)
data5$id <- factor(data5$id,levels = sample_seq2)
ggplot(data5,aes(x=id,y=percent))+
  geom_bar(stat="identity",aes(fill=k),width=1)+
  theme_cowplot()+
  theme(axis.text.x=element_text(angle = 90, hjust = 1,vjust = 0.5),
        panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = c("#CC6A6A","#6baed6","#F2B686","#d9a79c","#99d8c9")
  )
ggsave("str.5.pdf",width = 12,height = 3)

data6 <- read.table("Pop.extract.6.result.ggplot",header = T)
data6$id <- factor(data6$id,levels = sample_seq2)
ggplot(data6,aes(x=id,y=percent))+
  geom_bar(stat="identity",aes(fill=k),width=1)+
  theme_cowplot()+
  theme(axis.text.x=element_text(angle = 90, hjust = 1,vjust = 0.5),
        panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = c("#6baed6","#fb6a4a","#F2B686","#99d8c9","#d9a79c","#CC6A6A")
  )
ggsave("str.5.pdf",width = 12,height = 3)

t <- data.frame(tmp = 1:5,C = c(1.046,0.805,0.749,0.776,0.765) )
ggplot(t,aes(x=tmp,y=C)) +
  geom_line(linetype = "dashed")+
  geom_point(size = 2)+
  theme_bw()+
  theme(panel.grid = element_blank())+
  scale_y_continuous(limits = c(0.7,1.1))+
  labs(x="",y="Cv errors")
