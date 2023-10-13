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

plot_bais <- function(x){
  input <- as.character(str_glue("2.fpkm_compare.",x,".txt"))
  out_plot <- as.character(str_glue(x,".pdf"))
  data <- read_delim(input,delim="\t") %>% 
    filter(Class == "Normal",Exp_class == "all")
  data$Log2FC <- as.numeric(data$Log2FC)
  mean = median(data$Log2FC)
  print(mean)
  mean2 = filter(data,Bias != "no_bias") %>%
    select(Log2FC) %>%
    as.data.frame()
  mean2 = median(mean2$Log2FC)
  print(mean2)
  p1 <- ggplot(data)+
    geom_histogram(aes(x=Log2FC,fill = Bias),binwidth = 1,colour= "white",position = "identity",boundary=0)+
    labs(x="Log2Foldchang",y="Gene count")+
    theme_classic()+
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    )+
    scale_x_continuous(
      breaks = seq(-8,8,2),limits = c(-8,8)
    )+
    scale_y_continuous(
      limits = c(0,9000)
    )+
    scale_fill_manual(
    #values = c("#fb8072","grey80","#80b1d3")
    values = c("#5DD3B0","grey80","#FC923B")
    )+
    geom_vline(aes(xintercept = mean),colour="#ff7f00",size=0.6,alpha = 2/3,linetype="dashed")+
    theme(
      legend.position = "none"
    )
  ggsave(out_plot,p1,width = 5,height = 3)
}

test_2 <- function(data,x){
  d1 <- data %>% filter(Subgenome == "D",Group == x) %>% 
    select(gene,Subgenome,TEratio,Pair)
  d2 <- data %>% filter(Subgenome == "S",Group == x) %>% 
    select(gene,Subgenome,TEratio,Pair)
  dd1 <- bind_cols(d1,d2)
  identical(dd1[,4],dd1[,8])
  dd1[,9] <- paste(dd1[,2],dd1[,6],sep = "-")
  dd1[,10] <- dd1[,3]-dd1[,7]
  dd1 <- dd1[,c(3,7,9,10)]
  tmp_1 <- wilcox.test(dd1[,1],dd1[,2],paired=T)
  
  d1 <- data %>% filter(Bias == "dominant",Group == x) %>% 
    select(gene,Bias,TEratio,Pair)
  d2 <- data %>% filter(Bias == "submissive",Group == x) %>% 
    select(gene,Bias,TEratio,Pair)
  dd2 <- bind_cols(d1,d2)
  identical(dd2[,4],dd2[,8])
  dd2[,9] <- paste(dd2[,2],dd2[,6],sep = "-")
  dd2[,10] <- dd2[,3]-dd2[,7]
  dd2 <- dd2[,c(3,7,9,10)]
  tmp_2 <- wilcox.test(dd2[,1],dd2[,2],paired=T)
  r_list <- list(tmp_1,tmp_2,dd1,dd2)
  return(r_list)
}

data1 <- read.table("EC.compare_repeat_between_dom_and_undom.new.filter_homo.txt")
data2 <- read.table("ABR113.compare_repeat_between_dom_and_undom.new.filter_homo.txt")
data3 <- read.table("Bhyb26.compare_repeat_between_dom_and_undom.new.filter_homo.txt")
data1$group <- "Bhyb-EC"
data2$group <- "Bhyb-ABR113"
data3$group <- "Bhyb-26"
data_1 <- bind_rows(data1,data2,data3)
colnames(data_1) <- c("gene","Subgenome","Bias","TEratio","Pair","Group")
data_1$Group <- factor(data_1$Group,levels = c("Bhyb-EC","Bhyb-ABR113","Bhyb-26"))
tmp_symnum <- list(cutpoints = c(0, 0.01, 0.05, 1), symbols = c("**", "*", "ns"))

ggplot(data_1,aes(x=Subgenome,y=TEratio)) +
  geom_violin(aes(fill = Subgenome),width=0.5,trim=T, color = "white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  theme_cowplot()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(values = c("#FF425D","#00BFFF"))+
  scale_y_continuous(breaks = seq(0,1,0.2),limits = c(-0.001,1.1))+
  labs(x="",y = "TE Ratio",title = "Grouped by subgenome") +
  facet_wrap(.~Group)+
  stat_compare_means(comparisons =  list(c("D","S")),
                     method = "wilcox.test", label = "p.format",
                     method.args = list(paired=T))

ggplot(data_1,aes(x=Bias,y=TEratio)) +
  geom_violin(aes(fill = Bias),width=0.5,trim=F, color = "white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  theme_cowplot()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = c("#92c5de","#b2abd2")
  )+
  scale_y_continuous(
    breaks = seq(0,1,0.2),
    limits = c(0,1.1)
  )+labs(x="",y = "TE Ratio",title = "Grouped by HEP pattern")+
  facet_wrap(.~Group)+
  stat_compare_means(comparisons =  list(c("dominant","submissive")),
                     method = "wilcox.test", label = "p.format",
                     method.args = list(paired=T))

res_EC <- test_2(data_1,"Bhyb-EC")
res_ABR113 <- test_2(data_1,"Bhyb-ABR113")
res_26 <- test_2(data_1,"Bhyb-26")

data1 <- read.table("EC.z.compare_repeat_between_dom_and_undom.progenitor.txt")
data2 <- read.table("ABR113.z.compare_repeat_between_dom_and_undom.progenitor.txt")
data3 <- read.table("Bhyb26.z.compare_repeat_between_dom_and_undom.progenitor.txt")
data1$group <- "Bhyb-EC"
data2$group <- "Bhyb-ABR113"
data3$group <- "Bhyb-26"
data_2 <- bind_rows(data1,data2,data3)
colnames(data_2) <- c("gene","Subgenome","Bias","TEratio","Pair","Group")
data_2$Group <- factor(data_2$Group,levels = c("Bhyb-EC","Bhyb-ABR113","Bhyb-26"))
tmp_symnum <- list(cutpoints = c(0, 0.01, 0.05, 1), symbols = c("**", "*", "ns"))

ggplot(data_2,aes(x=Subgenome,y=TEratio)) +
  geom_violin(aes(fill = Subgenome),width=0.5,trim=T, color = "white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  theme_cowplot()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(values = c("#FF425D","#00BFFF"))+
  scale_y_continuous(breaks = seq(0,1,0.2),limits = c(-0.001,1.1))+
  labs(x="",y = "TE Ratio",title = "Grouped by genome (pregenitor)") +
  facet_wrap(.~Group)+
  stat_compare_means(comparisons =  list(c("D","S")),
                     method = "wilcox.test", label = "p.format",
                     method.args = list(paired=T))

ggplot(data_2,aes(x=Bias,y=TEratio)) +
  geom_violin(aes(fill = Bias),width=0.5,trim=F, color = "white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  theme_cowplot()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = c("#92c5de","#b2abd2")
  )+
  scale_y_continuous(
    breaks = seq(0,1,0.2),
    limits = c(0,1.1)
  )+labs(x="",y = "TE Ratio",title = "Grouped by HEP pattern (pregenitor)")+
  facet_wrap(.~Group)+
  stat_compare_means(comparisons =  list(c("dominant","submissive")),
                     method = "wilcox.test", label = "p.format",
                     method.args = list(paired=T))

res_EC_pre <- test_2(data_2,"Bhyb-EC")
res_ABR113_pre <- test_2(data_2,"Bhyb-ABR113")
res_26_pre <- test_2(data_2,"Bhyb-26")

data1 <- read.table("EC.z.homo_gene_repeat_var.txt")
data2 <- read.table("ABR113.z.homo_gene_repeat_var.txt")
data3 <- read.table("Bhyb26.z.homo_gene_repeat_var.txt")
data_config <- read_table("sp_color1.txt",col_names = F)
data_3 <- bind_rows(data1,data2,data3)
colnames(data_3) <- c("Dip","Ploy","Dipratio","Ployratio","Difference","Subgenome")
data_3$Subgenome <- factor(data_3$Subgenome,levels = data_config$X1)

ggplot(data_3,aes(x=Subgenome,y=Difference))+
  geom_violin(aes(fill = Subgenome),width = 1,trim=F, color = "white")+
  geom_hline(yintercept = 0,linetype = "dashed")+
  geom_boxplot(width=0.12,position=position_dodge(0.9),fill="white")+
  theme_cowplot()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = data_config$X2
  )+
  scale_y_continuous(
    breaks = seq(-1,1,0.2),
    limits = c(-1.1,1.1)
  )+labs(x="",y = "Difference value",title = "TEration's Difference with pregenitor")

ggplot(data_3)+
  geom_density(aes(x = Difference,color = Subgenome))+
  scale_x_continuous(
    breaks = seq(-1,1,0.2),
    limits = c(-0.25,0.25)
  )