def RemoveAllTagSections(wtextin):
	Tag = 0
	out=''
	wtext	=	string.split(wtextin,"\n")
	for nline in range(len(wtext)):
		s	= wtext[nline]
		s2	= string.lstrip(s)			# remove space
		if Tag == 0 and  string.find(s2,"<")==0 and string.find(s2,">")>0:
			Tag			= 1
			Tagkey		=	s[1:string.find(s,">")]
			Tagendkey	=	"</%s>" % Tagkey
		elif Tag==1:
			if string.find(s,Tagendkey)==0:	Tag	= 2
		if(Tag==0):	out = out + s2 + '\n'
		if(Tag==2): Tag=0
	return out