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


data1 <- read.table("5.compare_repeat_between_dom_and_undom.new.txt")
data2 <- read.table("5.compare_repeat_between_dom_and_undom.new.abr113.txt")
data3 <- read.table("5.compare_repeat_between_dom_and_undom.new.bd26.txt")
data1$group <- "Bhyb-ECI"
data2$group <- "Bhyb-ABR113"
data3$group <- "Bhyb-26"
data <- bind_rows(data1,data2,data3)
colnames(data) <- c("gene","Subgenome","Bias","TEratio","Pair","Group")
data$Group <- factor(data$Group,levels = c("Bhyb-ECI","Bhyb-ABR113","Bhyb-26"))
tmp_symnum <- list(cutpoints = c(0, 0.01, 0.05, 1), symbols = c("**", "*", "ns"))

ggplot(data,aes(x=Subgenome,y=TEratio)) +
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

ggplot(data,aes(x=Bias,y=TEratio)) +
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

data <- read.table("5.compare_repeat_between_dom_and_undom.new.txt")
colnames(data) <- c("gene","Subgenome","Bias","TEratio","Pair")
d1 <- data %>% filter(Subgenome == "D") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Subgenome == "S") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
wilcox.test(dd[,2],dd[,5],paired=T)

d1 <- data %>% filter(Bias == "dominant") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Bias == "submissive") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
identical(dd[,3],dd[,6])
wilcox.test(dd[,2],dd[,5],paired=T,alternative = "less")

data <- read.table("5.compare_repeat_between_dom_and_undom.new.abr113.txt")
colnames(data) <- c("gene","Subgenome","Bias","TEratio","Pair")

d1 <- data %>% filter(Subgenome == "D") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Subgenome == "S") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
wilcox.test(dd[,2],dd[,5],paired=T)

d1 <- data %>% filter(Bias == "dominant") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Bias == "submissive") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
identical(dd[,3],dd[,6])
wilcox.test(dd[,2],dd[,5],paired=T,alternative = "less")

data <- read.table("5.compare_repeat_between_dom_and_undom.new.bd26.txt")
colnames(data) <- c("gene","Subgenome","Bias","TEratio","Pair")

d1 <- data %>% filter(Subgenome == "D") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Subgenome == "S") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
identical(dd[,3],dd[,6])
wilcox.test(dd[,2],dd[,5],paired=T)

d1 <- data %>% filter(Bias == "dominant") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Bias == "submissive") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
identical(dd[,3],dd[,6])
wilcox.test(dd[,2],dd[,5],paired=T,alternative = "less")

data <- read.table("4.compare_kaks_between_dom_and_undom.new.filter.txt")
colnames(data) <- c("gene","Subgenome","Bias","NG86","YN00","Pair")
d1 <- data %>% filter(Subgenome == "D") %>% select(gene,YN00,Pair)
d2 <- data %>% filter(Subgenome == "S") %>% select(gene,YN00,Pair)
dd <- bind_cols(d1,d2)
wilcox.test(dd[,2],dd[,5],paired=T)

d1 <- data %>% filter(Bias == "dominant") %>% select(gene,YN00,Pair)
d2 <- data %>% filter(Bias == "submissive") %>% select(gene,YN00,Pair)
dd <- bind_cols(d1,d2)
identical(dd[,3],dd[,6])
wilcox.test(dd[,2],dd[,5],paired=T)

a <- ggplot(data,aes(x=Subgenome,y=YN00))+
  geom_violin(aes(fill = Subgenome),width=0.5,trim=T,color="white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  theme_cowplot()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(values = c("#FF425D","#00BFFF"))+
  labs(x="",y = "Ka/Ks",title = "Grouped by subgenome") +
  stat_compare_means(comparisons =  list(c("D","S")),
                     method = "wilcox.test", label = "p.format",
                     method.args = list(paired=T))

b <- ggplot(data,aes(x=Bias,y=YN00)) +
  geom_violin(aes(fill = Bias),width=0.5,trim=T, color = "white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  theme_cowplot()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = c("#92c5de","#b2abd2")
  )+
  labs(x="",y = "Ka/Ks",title = "Grouped by HEP pattern")+
  stat_compare_means(comparisons =  list(c("dominant","submissive")),
                     method = "wilcox.test", label = "p.format",
                     method.args = list(paired=T))
cowplot::plot_grid(a,b) 
