package xtaledit;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Properties;

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
 *  Property Handler
 */
/**
 * Property Handler
 */
public class Property {

	private final static boolean DBG = false;       // DBG_CHANGE
	
	//private final static String PROP_FILE = ".properties";
	private String PROP_FILE = null;
	
	private final static String defaultValue = null;
	
	private String header = null;
	
	private Properties properties=null;

	/**
	*   Constructs and initializes
	*/
	public Property(){
		PROP_FILE = "./font.properties";
		
		//header = new String(DialogApp.APPNAME + ' ' + DialogApp.getVersion());
	//	header = new String(platform.edit.AppInfo.APPNAME + ' ' + platform.edit.AppInfo.getVersion());
		
		properties = new Properties();
			//load();
	}
	
	public Property(String pfile,String header){
		this.PROP_FILE = pfile;
		this.header = header;
		properties = new Properties();
	}

	/**
	*    Load Property
	*/
	public int load() {
		if(!Util.exFile(PROP_FILE)) return(-1);
		
		try{
			FileInputStream in = new FileInputStream(PROP_FILE);
			properties.load(in);
			if(DBG) {
				MsgManager.print(this,"(load) ");
				properties.list(System.out);
			}
			in.close();
			return(0);
		} catch(Exception e) {
			MsgManager.errDialog(this,"Error loading Properties",e,null);
			return(-1);
		}
	}

	/**
	*    Store Property
	*/
	public void store() {
		try{
			FileOutputStream out = new FileOutputStream(PROP_FILE);
			properties.store(out,header);
			if(DBG) {
				MsgManager.print(this,"(store) ");
				properties.list(System.out);
			}
			out.close(); 
		} catch(Exception e) {
			MsgManager.errDialog(this,"Error Saving Properties",e,null);
		}
	}

	/**
	*    get Property
	*/
	public String getProperty(String key) {
		return(properties.getProperty(key, defaultValue));
	}

	/**
	*    set Property
	*/
	public void setProperty(String key, String value) {
		Object obj = properties.setProperty(key,value);
	}
}

