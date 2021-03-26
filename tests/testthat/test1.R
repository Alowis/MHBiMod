data(porto)
AnalogSel(fire01meantemp)
tr1=0.9
tr2=0.9
fire01meantemp=na.omit(fire01meantemp)
blss=Margins.mod(tr1,tr2,u=fire01meantemp)

pp=blss[[1]]
uu=blss[[2]]

interh<-"casc" #"comb or "casc"
upobj=0.001
vtau<-cor.test(x=fire01meantemp[,1],y=fire01meantemp[,2],method="kendall")$estimate

jtres<-JT.KDE.ap(u2=fire01meantemp,pb=0.01,pobj=upobj,beta=100,vtau=vtau,devplot=F,mar1=uu[,1],mar2=uu[,2],px=pp[,1],py=pp[,2],interh=interh)

plot(jtres$levelcurve)
wq0ri=jtres$wq0ri
wqobj<-removeNA(jtres$levelcurve)
wqobj<-data.frame(wqobj)
wq0ri<-jtres$wq0ri
wqobj[,1]=jitter(wqobj[,1])
plot(wqobj)
jtres$etaJT
jtres$chiJT
