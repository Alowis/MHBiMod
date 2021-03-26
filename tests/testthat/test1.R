data(porto)
AnalogSel(fire01meantemp)
tr1=0.9
tr2=0.9
fire01meantemp=na.omit(fire01meantemp)
blss=Margins.mod(tr1,tr2,u=fire01meantemp)

jtres<-JT.KDE.ap(u2=fire01meantemp,pb=0.01,pobj=upobj,beta=100,vtau=vtau,devplot=F,mar1=u1b,mar2=u2b,px=pxfp,py=pyfp,interh=interh)

plot(jtres$levelcurve)
wq0ri=jtres$wq0ri
wqobj<-removeNA(jtres$levelcurve)
wqobj<-data.frame(wqobj)
wq0ri<-jtres$wq0ri
wqobj[,1]=jitter(wqobj[,1])
plot(wqobj)
jtres$etaJT
jtres$chiJT
