import string
def RemoveTaggedSection(winput,Tagk):
	wtext = string.split(winput, "\n")	# wtext is splitted to each lines
	Tagkey		=	"<%s>"  % Tagk
	Tagendkey	=	"</%s>" % Tagk
	print ' remove between',Tagkey,Tagendkey
	Tag = 0
	out=''
	for nline in range(len(wtext)):
		s	= wtext[nline]
		s2	= string.lstrip(s)			# remove space
		
#		print s2, string.find(s2,Tagkey)
		if Tag == 0 and  string.find(s2,Tagkey)==0:
			Tag	= 1
		elif Tag==1:
			if string.find(s,Tagendkey)==0: Tag	= 2
##		if(Tag==0):	out = out + s2 + '\n'
		if(Tag==0): out = out + s + '\n'
		if(Tag==2): Tag=0

	if(Tag!=0): return "Tag is not closed!"
	return out