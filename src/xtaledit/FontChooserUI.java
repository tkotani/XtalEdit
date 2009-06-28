package xtaledit;
import java.awt.Font;
import java.awt.Frame;

/*
 * Created on 2003/07/29
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */

/**
 * @author Goto Ryuichi
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
/*
 * FontChooser UI with Property
 */
public class FontChooserUI {

	private final static boolean DBG = false;  // DBG_CHANGE
	
	private final static String PROP_Name = "Font.Name";
	private final static String PROP_Style = "Font.Style";
	private final static String PROP_Size = "Font.Size";
	
	private final static String DefaultfontName  = "Monospaced";
	private final static int    DefaultfontStyle =  0;
	private final static int    DefaultfontSize  = 12;
	//Font fon = new java.awt.Font("Monospaced", 0, 12);
	
	Font newfon=null;
	
	//public FontChooserUI(Frame frm)
	
	/**
	*   Constructs and initializes
	*/
	public FontChooserUI(Frame frm,Font nowfon){
		// Usage! Font fon = txtar.getFont();
		//        Font fon = FontChooserUI.getFontfromProperty();
		//          or null

		Font fon = nowfon;
		if(fon==null) fon = getFontfromProperty();
		
		if(DBG) MsgManager.print(this,"(FontChooserUI) " + fon);
		
		FontChooser fc = new FontChooser(frm,true,"Font",fon);
		
		if(fc.ok) {
			newfon = fc.getCurrentFont();
			if(DBG) MsgManager.print(this,"(FontChooserUI) " + newfon);
			saveProperty(fc.currentName,fc.currentStyle,fc.currentSize);
		}
		
		if(DBG && fc.ok) {
			//ref.
			//newfon.getName())
			//fc.styleToString(newfon.getStyle())
			//Integer.toString(newfon.getSize()))
			
			MsgManager.print(this,"(FontChooserUI) " + 
				fc.ok + " " +
				fc.currentName + " " + fc.currentStyle + " " + fc.currentSize);
		}
		
		fc.dispose();
		
		/* ref. Other Usage
		Font newfon = FontChooser.showDialog(this,"ttt",fon);
		MsgManager.print(this,"() " + newfon);
		*/
		
		//txtpyt.setTabSize(4);
		//txtpyt.setFont(newfon);
	}
	
	/**
	*  show Dialog
	*/
	public static Font showDialog(Frame frm,Font fon){
		FontChooserUI fcui = new FontChooserUI(frm,fon);
		Font nfon = fcui.getSelectFont();
		return(nfon);
	}
		
	/**
	*  Get Select Font
	*/
	public Font getSelectFont() {
		return(newfon);
	}

	/**
	*  Get Now Setting Font
	*/
	/*
	public static synchronized Font getFont() {  // getFontfromProperty
		if(!loadProperty()) {
			fName = "Monospaced"
			fStyle = 0;
			fSize = 12;
		}
		return(new Font(fName, fStyle, fSize));
	}
	String fName = null;
	int fStyle = -1;
	int fSize = -1;
	*/
	

	
	/**
	*  Get Now Setting Font (inc Load Property)
	*/
	public static synchronized Font getFontfromProperty() {
		//private static synchronized boolean loadProperty() {
		
		String fName = DefaultfontName;
		int fStyle   = DefaultfontStyle;
		int fSize    = DefaultfontSize;
	
		Property prop = new Property();
		int ret = prop.load();
		
		//prop-file exist
		if(ret==0) {
			String str;
			
			str = prop.getProperty(PROP_Name);
			if(str!=null) fName = str;
			
			str = prop.getProperty(PROP_Style);
			if(str!=null) fStyle = Math2.s_i(str);
			
			str = prop.getProperty(PROP_Size);
			if(str!=null) fSize = Math2.s_i(str);
		}
		
		//prop-file Not exist or Not def
		else if(ret==-1) {
		}
		
		if(DBG) MsgManager.print("(getFontfromProperty) " + fName + " " + fStyle + " " + fSize);
		
		return(new Font(fName, fStyle, fSize));
		
	}

	/**
	*    Save Property
	*/
	private void saveProperty(String fName,int fStyle,int fSize) {
		Property prop = new Property();
		int ret = prop.load();
		
		if(newfon==null) return;
		
		String str;
		
		str = fName;
		prop.setProperty(PROP_Name,str);
		
		str = Math2.i_s(fStyle);
		prop.setProperty(PROP_Style,str);
		
		str = Math2.i_s(fSize);
		prop.setProperty(PROP_Size,str);
		
		prop.store();
	}

}
