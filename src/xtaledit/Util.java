package xtaledit;
import java.awt.Component;
import java.awt.Container;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Frame;
import java.awt.GraphicsEnvironment;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.Window;
import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Properties;

import javax.swing.JFrame;
import javax.swing.UIManager;

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
/**
*    Util
*/
public class Util extends Object
{
	private final static boolean DBG = false;  // DBG_CHANGE
	
	/**
	*   util Constructor
	*/
	private Util() {}
	
	private static long swtime = 0;
	
	/**
	*    Set Locale
	*/
	public static synchronized void set_locale_us() {
		
		try {
			//Locale.setDefault(new Locale("Locale.ENGLISH","Locale.JAPAN"));
			java.util.Locale.setDefault(new java.util.Locale("Locale.ENGLISH","Locale.JAPAN"));
			//Sets the default locale for the whole JVM. Normally set once at the beginning of an application
		} catch(SecurityException  e) {
			MsgManager.print("(set_locale_us) Exception:\n" , e);
		}
			//"Locale.ENGLISH","Locale.US"
			//"Locale.JAPANESE","Locale.JAPAN"
			//java.util.Locale.setDefault(java.util.Locale.ENGLISH);
			//Locale loc = new Locale("fr", "CA", "UNIX");
	}

	/**
	*    Seach Parent JFrame
	*/
	public static synchronized JFrame get_Frame(Component com) {
		Component c = com;
		while(c != null && !(c instanceof JFrame)) {
			c = c.getParent();
		}
		if(c==null) {
			//MsgManager.print("(get_Frame) Cannot find JFrame");
			return(null);
		}   
		else {
			return((JFrame)c);
		}
	}

	/**
	*    Get Frame info
	*/
	public static synchronized Rectangle tstget_FrameInf(Component com) {   //  (Not use)
		Rectangle wr = get_Frame(com).getBounds();  // width,height,x,y
		if(DBG) {
			Point wp = get_Frame(com).getLocation();
			Point sp = get_Frame(com).getLocationOnScreen();
			MsgManager.print("wr:" + wr);
			MsgManager.print("wp:" + wp);
			MsgManager.print("sp:" + sp);
		}
		return(wr);
		/* ref.
		wr:java.awt.Rectangle[x=214,y=72,width=601,height=774]
		wp:java.awt.Point[x=214,y=72]
		sp:java.awt.Point[x=214,y=72]
		*/	
	}
	
	/**
	*    Get Screen info
	*/
	public static synchronized Dimension getScreenSize() {  // Test done (Not use)
		Dimension sd = Toolkit.getDefaultToolkit().getScreenSize();
		return(sd);
	}
		
	/**
	*    Centering Frame On parent Comp
	*/
	public static synchronized void centerCmp(Component parent,Component child) { 
		Point p = parent.getLocation();
		Dimension pd = parent.getSize();
		Dimension cd = child.getSize();
	
		p.translate((pd.width - cd.width) / 2, (pd.height - cd.height) / 2);
		//check out screen-
		int sx= Math2.max((int)p.getX(),0); int sy = Math2.max((int)p.getY(),0);
		p.setLocation(sx,sy);
		//-
		child.setLocation(p); 
	}
	
	/**
	*    Centering Frame On screen
	*/
	public static synchronized void centerCmp(Component child) {
		Point p = new Point(0,0);
		Dimension pd = Util.getScreenSize();
		Dimension cd = child.getSize();
	
		p.translate((pd.width - cd.width) / 2, (pd.height - cd.height) / 2);
		//check out screen-
		int sx= Math2.max((int)p.getX(),0); int sy = Math2.max((int)p.getY(),0);
		p.setLocation(sx,sy);
		//-
		child.setLocation(p); 
	}

	/**
	*    get DC Location Inside Screen about component(need vis)
	*/
	public static synchronized boolean getLocationInsideScreen(Component com,Point dcp) {
		int scw = getScreenSize().width;
		int sch = getScreenSize().height;
		int cw = com.getWidth();
		int ch = com.getHeight();
		Point cp = com.getLocationOnScreen();
		int sx = cp.x;
		int sy = cp.y;
		boolean upd=false;
		if(sx+cw > scw) {
			sx = Math2.max(0,scw-cw); upd = true;
		}
		if(sy+ch > sch) {
			sy = Math2.max(0,sch-ch); upd = true;
		}
		dcp.setLocation(sx,sy);
		return(upd);
	}
	
	/**
	*   Show Window
	*/
	public static synchronized void showWindow(JFrame f) {
		try{
			f.setVisible(true);
			//f.show();  // Deprecated.
			if(f.getState() ==Frame.ICONIFIED)
				f.setState(Frame.NORMAL);
			f.requestFocus();
		} catch (Exception e) {
			MsgManager.print("Exception in showWindow." , e);
		}            
	}
	
	/**
	*   Front Frame
	*/
	public static synchronized void toFrontWin(Window f) {
		f.toFront();
		
		//More Try For BUG?
		for(int i=0;i<1;i++) { // 1
			//MsgManager.print("(front) i:" + i); 
			Util.sleep(300);  // 300
			f.toFront();
			f.setVisible(true);
		}
	}
	
	/**
	*    Change Cursor Type on component (also Container)      
	*/
	public static synchronized void setCursor(Component com,int typ) {
		int ctyp = Cursor.DEFAULT_CURSOR;     // java.awt.Cursor.DEFAULT_CURSOR
		if     (typ==1)   ctyp = Cursor.DEFAULT_CURSOR;
		else if(typ==2)   ctyp = Cursor.CROSSHAIR_CURSOR;
		else if(typ==3)   ctyp = Cursor.TEXT_CURSOR;
		else if(typ==4)   ctyp = Cursor.HAND_CURSOR;
		else if(typ==999) ctyp = Cursor.WAIT_CURSOR;
		Cursor crs = java.awt.Cursor.getPredefinedCursor(ctyp);
		com.setCursor(crs);
	}

	/**
	*    Change Cursor Type on component & Children     
	*/
	public static synchronized void setCursorAll(Container con,int typ) {
		setCursor(con,typ);
		Component coms[] = con.getComponents();
		if(coms!=null) {
			for(int i=0;i<coms.length;i++) setCursor(coms[i],typ);
		}
	}
	
	/**
	*    Change Cursor Type on upper parent JFrame     
	*/
	public static synchronized void setCursor_JFrame(Component com,int typ) {  // Not use
		int ctyp = Cursor.DEFAULT_CURSOR;   //Old type! Frame.DEFAULT_CURSOR;
		if     (typ==1)   ctyp = Cursor.DEFAULT_CURSOR;
		else if(typ==2)   ctyp = Cursor.CROSSHAIR_CURSOR;
		else if(typ==3)   ctyp = Cursor.TEXT_CURSOR;
		else if(typ==4)   ctyp = Cursor.HAND_CURSOR;
		else if(typ==999) ctyp = Cursor.WAIT_CURSOR;
		Cursor crs = java.awt.Cursor.getPredefinedCursor(ctyp);
		Util.get_Frame(com).setCursor(crs);
		//Old type! Util.get_Frame(com).setCursor(ctyp);
	}
		// ref. Frame  DEFAULT_CURSOR   NORMAL  WAIT_CURSOR  HAND_CURSOR  MOVE_CURSOR  TEXT_CURSOR

	/**
	*    move Cursor Position    
	*/
	public static synchronized void moveCursor(Component com,int x, int y) { 
		try {
			Robot rob = new Robot();
			int sx = x;
			int sy = y;
			if(com!=null) {
				Point p = com.getLocationOnScreen();
				sx = p.x + x; sy = p.y + y;
			}
			rob.mouseMove(sx,sy);
			rob=null;
		} catch (Exception e) {
			MsgManager.print("Exception in moveCursor." , e);
		}
	}
	
	/**
	*    flush Event   
	*/
	public static synchronized void flushEvent() { 
		try {
			Robot rob = new Robot();
			rob.waitForIdle();
			rob=null;
		} catch (Exception e) {  // IllegalThreadStateException
			MsgManager.print("Exception in flushEvent." , e);
		}
	}
	
	/**
	*    Beep
	*/
	public static synchronized void beep(int cnt) {
		//java.awt.Toolkit  ?? beep() 
		System.out.print("\07"); 
		System.out.flush();
	}

	/**
	*    is Caps Lock
	*/
	public static synchronized boolean isCapsLock() {
		return(java.awt.Toolkit.getDefaultToolkit().getLockingKeyState(java.awt.event.KeyEvent.VK_CAPS_LOCK));
			// VK_NUM_LOCK
	}
	
	/**
	*    Change LookAndFeel  // javax.swing.UIManager
	*                     ref. if Create Component, Must xxxx.updateUI();
	*/
	public static synchronized void setNativeLook() {
		try {
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		} 
		catch (Exception e) {
			MsgManager.errDialog("fail at setNativeLook." , e, null);
		}
	}
	
	public static synchronized void setCrossPlatformLook() {
		try {
			UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
		} 
		catch (Exception e) {
			MsgManager.errDialog("fail at setCrossPlatformLook." , e, null);
		}
	}
	
	public static synchronized void set_Look() {  // BasicLookAndFeel, MultiLookAndFeel 
		String mac   = new String("com.sun.java.swing.plaf.mac.MacLookAndFeel");
		String win   = new String("com.sun.java.swing.plaf.windows.WindowsLookAndFeel"); 
		String motif = new String("com.sun.java.swing.plaf.motif.MotifLookAndFeel");
		String meta  = new String("com.sun.java.swing.plaf.metal.MetalLookAndFeel");   // default
		
		/*  ?? Not work ?? 
		String win   = new String("javax.swing.plaf.windows.WindowsLookAndFeel"); 
		String motif = new String("javax.swing.plaf.motif.MotifLookAndFeel");
		String meta  = new String("javax.swing.plaf.metal.MetalLookAndFeel");   // default
		*/
		
		UIManager.LookAndFeelInfo[] inf2 = UIManager.getInstalledLookAndFeels();
		for(int i = 0; i < inf2.length; i++ ) {
			MsgManager.print("(set_Look) " + i + " " + inf2[i].getName());
		}
		MsgManager.print("(set_Look) >> " + UIManager.getLookAndFeel().getName());
		/*
		try{
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
			//MsgManager.print("(set_Look) " + UIManager.getSystemLookAndFeelClassName());
		} catch(java.lang.Exception e) {}
		*/
		
		try{
			UIManager.setLookAndFeel(mac);
		} catch(java.lang.Exception e1) {
			try{
				UIManager.setLookAndFeel(win);
			} catch(java.lang.Exception e2) {
				try{
					UIManager.setLookAndFeel(motif);
				} catch(java.lang.Exception e3) {
					try{
						UIManager.setLookAndFeel(meta);
					} catch(java.lang.Exception e4) {
						e4.printStackTrace(System.out);
					}
				}
			}
		}
		MsgManager.print("(set_Look) >>>> " + UIManager.getLookAndFeel().getName());
    
	}

	public boolean isNativeLookAndFeel() {
		String osName = System.getProperty("os.name");
		return (osName != null) &&(osName.indexOf("Solaris") != -1);
		// isSupportedLookAndFeel();
	}
	
	/**
	*    Get file exist info
	*/
	public static synchronized boolean exFile(String fnm) {
		if(fnm==null) return(false);
		File f = new File(fnm);
		return(f.exists()); 
	}

	/**
	*    Get file Size
	*/
	public static synchronized long getFileSize(String fnm) {
		if(fnm==null) return(0);
		File f = new File(fnm);
		if(!f.exists()) return(0);
		return(f.length()); 
	}
	
	/**
	*    Get file Read status
	*/
	public static synchronized boolean isFileRead(String fnm) {
		if(fnm==null) return(false);
		File f = new File(fnm);
		return(f.canRead()); 
	}

	/**
	*    Get file Read/Write status
	*/
	public static synchronized boolean isFileWrite(String fnm) {
		if(fnm==null) return(false);
		File f = new File(fnm);
		return(f.canWrite());
	}
	
	/**
	*   Get file name from fullpathFilename
	*/
	public static synchronized String getFnmFromPath(String fnm) {
		if(fnm==null) return(null);
		File f = new File(fnm);
		//if(!f.exists()) return(null);  // com for when none file
		return(f.getName());
	}
	
	/**
	*   Get Dir name from fullpathFilename
	*/
	public static synchronized String getDnmFromPath(String fnm) {
		if(fnm==null) return(null);
		File f = new File(fnm);
		return(f.getParent());  // Last char Not inc \
		//return(f.getPath());  -> same fnm
	}

	/**
	*    is Directory
	*/
	public static synchronized boolean isDirectory(String path) {
		File f = new File(path);
		return(f.isDirectory());
	}

	/**
	*   is file
	*/
	public static synchronized boolean isFile(String path) {
		File f = new File(path);
		return(f.isFile());
	}
		
	/**
	*   Make Folder
	*/
	public static synchronized boolean mkdir(String path) {
		File dir = new File(path);   // "c:\\newdir\\alsonew"  "c:\\new"
		if(dir.exists()) {
			if(dir.isFile()) {
				MsgManager.print("(mkdir) SameName file exist! " + path);
				return(false);
			}
			else return(true);
		}
		boolean ret = dir.mkdirs();  //  dir.mkdir();
		return(ret);
	}
	
	/**
	*   remove file
	*/
	public static synchronized boolean rmfile(String path) {
		File fl = new File(path);
		if(!fl.exists()) return(true);
		if(fl.isDirectory()) return(false);  // Not remove dir
		
		//MsgManager.print("(rmfile) del " + path);

		if(!fl.delete()) {
			MsgManager.print("(rmfile) Cannot del! " + path);
			return(false);
		}

		return(true);
	}

	/**
	*   remove files-in-dir
	*/
	public static synchronized boolean rmfilesInDir(String path) {
		return(rmDirFiles(path,false));
	}

	/**
	*   remove dir
	*/
	public static synchronized boolean rmdir(String path) {
		return(rmDirFiles(path,true));
	}

	/**
	*   remove dir or files-in-dir
	*/
	private static synchronized boolean rmDirFiles(String path,boolean sw_rmDir) {
		File dir = new File(path);
		if(!dir.exists()) return(true);
		if(!dir.isDirectory()) {
			MsgManager.print("(rmDirFiles) Not dir. " + path);
			return(false);
		}
		
		//del all file in dir
		String[] fnms = getNamesInDir(path,false);
		if(fnms!=null) {
			String sep = File.separator;
			for(int i=0;i<fnms.length;i++) {
				if(isFile(dir+sep+fnms[i])) rmfile(dir+sep+fnms[i]);
				else {
					if(sw_rmDir) rmDirFiles(dir+sep+fnms[i],true);  // now No test!
				}
			}
		}
		//
		//MsgManager.print("(rmdir) del " + path);
		if(sw_rmDir) {
			if(!dir.delete()) {
				MsgManager.print("(rmDirFiles) Cannot del! " + path);
				return(false);
			}
		}

		return(true);
	}

	/**
	*   get fileList in dir
	*/
	public static synchronized String[] getNamesInDir(String path,boolean sort) {
		if(path==null) return(null);
		
		File dir = new File(path);
		//String[] fnms = dir.list();
		File[] files = dir.listFiles(); // get files, not just names (!)
		if(files==null) return(null);
		int cnt = files.length;
		if(cnt==0) return(null);
		
		if(sort) Arrays.sort(files);
		String fnms[] = new String[cnt];
		for(int i=0;i<cnt;i++) fnms[i] = files[i].getName();  // getPath()
		return(fnms);
	}

	/**
	*   make temp file
	*/
	public static synchronized String makeTempFile(String prefix,String suffix,
		String dir,boolean sw_del) {
		//prefix is min 3-keta
		File directory = new File(dir);  // if null -> "/tmp" "/var/tmp"  "c:\\temp"
		File tmpf=null;
		try {
			tmpf = File.createTempFile(prefix,suffix,directory);
			if(sw_del) tmpf.deleteOnExit();
		} catch(Exception e) {MsgManager.print( "(makeTempFile) " , e); return(null);}
		return(tmpf.getPath());
	}
	
	/**
	*    get Suffix of filename
	*/
	public static synchronized String getSuffix(String path) {
		if(path==null || path.length()<=0) return(null);
		
		//String path = f.getPath();
		String suffix = null;
		int spos = path.lastIndexOf('.');

		if(spos > 0 && spos < path.length() - 1)
			suffix = path.substring(spos+1).toLowerCase();

		return(suffix);
	}

	/**
	*    Get time stamp
	*/
	public static synchronized long getTimeStamp() {  // msec  exp. 944206859870
		return(System.currentTimeMillis());
		
		//(other method)
		//Calendar cal = new GregorianCalendar();
		//Date dt = cal.getTime();
		//return(dt.getTime()); 
	}

	/**
	*    Stop Watch
	*/
	public static synchronized long stopwatch(boolean reset)
	{
		// Usage exp. stopwatch(true); t = stopwatch(); stopwatch(false);
		long result = 0L;
		if(reset) {
			swtime = getTimeStamp();
			result = swtime;
		} 
		else {
			long now = getTimeStamp();
			long dftime = now - swtime;
			swtime = now;
			result = dftime;
		}
		
		return(result);
	}
	public static synchronized long stopwatch()
	{
		return(getTimeStamp()-swtime);
		//return(stopwatch(false));
	}

	/**
	*    testDBG time
	*/
	public static synchronized String dbgtm_start()
	{
		String str = get_timefmt();
		stopwatch(true);  // here best much end time!
		return(str);
	}
	public static synchronized String dbgtm_end()
	{
		long etm = stopwatch(false);
		String str = get_timefmt() + " Elapsed " + etm/1000.0f + " sec";
		return(str);
	}
	public static synchronized void dbgtm_print(String com,int sten)
	{
		if(sten == 0) MsgManager.print(com + " Time:" + dbgtm_start());
		else          MsgManager.print(com + " Time:" + dbgtm_end());
		//printMemoryInfo();
	}
	
	/**
	*    Get Date format (yy/mm/dd hh:mm:ss)
	*/
	public static synchronized String get_datefmt() {
		//Calendar cal = Calendar.getInstance();
		Calendar cal = new GregorianCalendar();
		int yy = cal.get(Calendar.YEAR);         // yy(exp. 1999)
		int mm = cal.get(Calendar.MONTH)+1;      // mm (0:1gatu,1:2gatu,...)
		int dd = cal.get(Calendar.DAY_OF_MONTH); // dd
		//int wn = cal.get(Calendar.DAY_OF_WEEK);// wn (1:SUN,2:MON,...)
		int h  = cal.get(Calendar.HOUR_OF_DAY);  // h
		int m  = cal.get(Calendar.MINUTE);       // m
		int s  = cal.get(Calendar.SECOND);       // s
		int ms = cal.get(Calendar.MILLISECOND);  //ms
		
		String str = Math2.i_s(yy) + "/" + Math2.i_s(mm) + "/" + Math2.i_s(dd) + " "  +
					 Math2.i_s(h)  + ":" + Math2.i_s(m)  + ":" + Math2.i_s(s);
		return(str);
	}

	/**
	*    Get Date format (yy/mm/dd hh:mm:ss.ms)
	*/
	public static synchronized String get_timefmt() {
		Calendar cal = new GregorianCalendar();
		int yy = cal.get(Calendar.YEAR);         // yy(exp. 1999)
		int mm = cal.get(Calendar.MONTH)+1;      // mm (0:1gatu,1:2gatu,...)
		int dd = cal.get(Calendar.DAY_OF_MONTH); // dd
		int h  = cal.get(Calendar.HOUR_OF_DAY);  // h
		int m  = cal.get(Calendar.MINUTE);       // m
		int s  = cal.get(Calendar.SECOND);       // s
		int ms = cal.get(Calendar.MILLISECOND);  //ms
		
		String str =  Math2.i_s(yy) + "/" + Math2.i_s(mm) + "/" + Math2.i_s(dd) + " "  +
					  Math2.i_s(h)  + ":" + Math2.i_s(m)  + ":" + Math2.i_s(s) +  "." + Math2.i_s(ms);
		return(str);
		//MsgManager.print("xxx:" + new java.util.Date().toString());
	}

	/**
	*    make 000.. fmt numeric 
	*/
	public static synchronized String getPreZeroNum(int v,int keta) {
			DecimalFormat df=(DecimalFormat) DecimalFormat.getInstance();
			String fmt;
			if(keta<=0) {
				fmt = new String("#");
			}
			else {
				//? fmt = Math2.i_s(keta);
				fmt = "";
				for(int i=1;i<=keta;i++) fmt = fmt.concat("0");
			}
			df.applyPattern(fmt);
			String str = df.format(v);
			return(str);
	}
	
	/**
	*    Sleep
	*/
	public static synchronized void sleep(long sp) {	// msec
		try { Thread.sleep( sp ); }
		catch( InterruptedException e ) {MsgManager.print( "(sleep) " , e);}
	}
	
	/**
	*    Exec
	*/
	public static synchronized void exec(String cmd) {	
		try {
			Process proc = Runtime.getRuntime().exec(cmd);
				// "c:/windows/notepad.exe"
		} catch(IOException e) {MsgManager.print( "(exec) " , e);}
	}
	
	/**
	*    Get Font kind
	*/
	public static synchronized void init_font() {
		GraphicsEnvironment.getLocalGraphicsEnvironment().getAvailableFontFamilyNames();
		//GraphicsEnvironment.getLocalGraphicsEnvironment().getAllFonts();  // heavy???
	}
	public static synchronized String[] get_font() {
		Font[] fonts = GraphicsEnvironment.getLocalGraphicsEnvironment().getAllFonts();
		String nm[] = new String[fonts.length];
		for (int i=0; i<fonts.length; i++) {
			nm[i] = new String(fonts[i].getFontName());
			MsgManager.print("(get_font)" + nm[i]);
		}
		return(nm);
		
		/* same?
		GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
		String[] fnm = ge.getAvailableFontFamilyNames(Locale.JAPANESE);
		//for (int i = 0; i < fnm.length; i++) {
		//	Font f = new Font(fnm[i], Font.PLAIN, 1);
		//	MsgManager.print("(get_font)" + fnm[i] + " " + f.getFamily(Locale.JAPANESE));
		//}
		//comp err! String nm[] = GraphicsEnvironment.getAvailableFontFamilyNames();
		return(fnm);
		*/
		
		//ref.
		//final Choice fchoice = new Choice();
		//for (int i=0; i<fonts.length; i++) fchoice.add(fonts[i].getFontName());
		//dpanels[0].add(fchoice); 
	}
	
	/**
	*    Free Memory ( garbage collectioning)
	*      ref. At default, GC's priority is the lowest amongst all thread. 
	*/
	public static synchronized void mfree() {
		//System.out.flush();
		if(DBG) MsgManager.print("garbage collectioning...");
		System.runFinalization();
		System.gc();
		System.runFinalization();
		if(DBG) {
			MsgManager.print("garbage collectioning end");
			Util.printMemoryInfo();
		}
	}
	public static synchronized void rmfree() {
		if(DBG) MsgManager.print("garbage collectioning(runtime)...");
		Runtime rt = Runtime.getRuntime();
		rt.runFinalization();
		rt.gc();
		rt.runFinalization();
		if(DBG) {
			MsgManager.print("garbage collectioning(runtime) end");
			Util.printMemoryInfo();
		}
		//ref. Runtime.runFinalization() does not do a GC
	}
	
	/**
	*    Print Memory info
	*/
	public static synchronized void printMemoryInfo() {
		MsgManager.print("---------------------------------------------------------------------------");
		Runtime runtime = Runtime.getRuntime();
		long total = runtime.totalMemory();  // (1024*1024);
		long free = runtime.freeMemory();    // (1024*1024);
		long use = total - free;
		
		DecimalFormat df=(DecimalFormat) DecimalFormat.getInstance();
		df.applyPattern("#,###,###,###"); 
		String stotal = df.format(total);
		String sfree = df.format(free);
		String suse = df.format(use);
		
		MsgManager.print( "Memory used: " + suse + " total: " + stotal + " free: " + sfree);
		MsgManager.print("   Used-Percent: " + (((float)use/(float) total) *100.0f) +"%");
		MsgManager.print("---------------------------------------------------------------------------");
	}
	
	public static synchronized float get_rateUmemory() {
		Runtime runtime = Runtime.getRuntime();
		long total = runtime.totalMemory();
		long free = runtime.freeMemory();
		long use = total - free;
		float rate =  ((float)use/(float) total) *100.0f;
		return(rate);
	}
	
	public static synchronized long get_freeMemory() {
		Runtime runtime = Runtime.getRuntime();
		long free = runtime.freeMemory();
		return(free);
	}
	
	/**
	*    Sysinfo
	*/	
	public static synchronized void sysinfo_tst() {
		MsgManager.print("---------------------------");
		Properties doco = System.getProperties() ;
		doco.list( System.out ) ;
		MsgManager.print("---------------------------");
		MsgManager.print("fileSep(" + File.separator + ")");
	}   
}
