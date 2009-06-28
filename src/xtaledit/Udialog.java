package xtaledit;
import java.awt.Component;

import javax.swing.JOptionPane;

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
*    Util Dialog
*/
public class Udialog extends Object
{
	/**
	*   Util Dialog Constructor
	*/
	private Udialog() {}

	/**
	*   Error Dialog
	*/
	public static void err(Component com,String msg) {
		Object[] options = { "OK"};
		JOptionPane.showOptionDialog(Util.get_Frame(com), msg, "Error Message", 
			JOptionPane.DEFAULT_OPTION, JOptionPane.ERROR_MESSAGE ,null, options, options[0]);
	}
	
	/**
	*   Warning Dialog
	*/
	public static void war(Component com,String msg) {
		Object[] options = { "OK"};
		JOptionPane.showOptionDialog(Util.get_Frame(com), msg, "Warning Message", 
			JOptionPane.DEFAULT_OPTION, JOptionPane.WARNING_MESSAGE ,null, options, options[0]);
	}
	
	/**
	*   Infomation Dialog
	*/
	public static void inf(Component com,String msg) {
		Object[] options = { "OK"};
		JOptionPane.showOptionDialog(Util.get_Frame(com), msg, "Infomation Message", 
			JOptionPane.DEFAULT_OPTION, JOptionPane.INFORMATION_MESSAGE ,null, options, options[0]);
	}
	
	/**
	*   Confirm Dialog (Yes,No)
	*/
	public static boolean YesNo(Component com,String msg,boolean sw) {
		int dno;  // default button#
		dno = (sw ? 0:1);  //
		
		Object[] options = { "Yes","No"};
		int ans = JOptionPane.showOptionDialog(Util.get_Frame(com), msg, "Confirm Message", 
			JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE ,null, options, options[dno]);
			
		Util.sleep(200);   // For Hung UP  -> effect?
		
		if(ans==JOptionPane.YES_OPTION) return(true);  // yes
		else                            return(false); // no
	}
	
	/**
	*   Confirm Dialog (OK,Cancel)
	*/
	public static boolean OKCancel(Component com,String msg,boolean sw) {
		int dno;  // default button#
		dno = (sw ? 0:1);  //
		
		Object[] options = { "OK","Cancel"};
		int ans = JOptionPane.showOptionDialog(Util.get_Frame(com), msg, "Confirm Message", 
			JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE ,null, options, options[dno]);
			
		Util.sleep(200);   // For Hung UP  -> effect?
		
		if(ans==JOptionPane.YES_OPTION) return(true);  // OK
		else                            return(false); // Cancel
	}
	
	//Next OK, But Appearence of defaultButton is Reverse!
	public static boolean XCancelOK(Component com,String msg,boolean sw) {
		int dno;  // default button#
		dno = (sw ? 1:0);  //
		
		Object[] options = { "Cancel","OK"};
		int ans = JOptionPane.showOptionDialog(Util.get_Frame(com), msg, "Confirm Message", 
			JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE ,null, options, options[dno]);
			
		Util.sleep(200);   // For Hung UP  -> effect?
		
		if(ans==JOptionPane.YES_OPTION) return(false);  // Cancel
		else                            return(true);   // OK
	}
	
	//Note. synchronized -> yesno is Hung another thread(exp. autoRefresh)
	
	/*
	public static void YesNoCancel(Component com,String msg) {
		Object[] options = { "Yes","No","Cancel"};
		int ans = JOptionPane.showOptionDialog(Util.get_Frame(com), msg, "Confirm Message", 
			JOptionPane.YES_NO_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE ,null, options, options[0]);
	}
	*/
		// OK_CANCEL_OPTION 
		/*
		YES_OPTION,
		NO_OPTION,
		CANCEL_OPTION,
		OK_OPTION, or
		CLOSED_OPTION.
		*/

	/*
	public static void confirm(Component com,String msg) {
		JOptionPane.showConfirmDialog(Util.get_Frame(com),msg,"Confirm Message",
			JOptionPane.YES_NO_OPTION);
	}
	*/

	/**
	*   Input String Dialog (OK,Cancel) - textfield
	*/
	public static String inputString(Component com,String title,String msg,String initselVal) {
			return(selectString(com,title,msg,initselVal,null));
			//return(JOptionPane.showInputDialog(msg));
	}

	/**
	*   Select String Dialog (OK,Cancel) - textfield/combo
	*/	
	public static String selectString(Component com,String title,String msg,String initselVal,String[] selVal)  {
		
		String str = (String)JOptionPane.showInputDialog(
			Util.get_Frame(com), msg, title, 
			JOptionPane.QUESTION_MESSAGE, null, selVal, initselVal);
				//ERROR_MESSAGE INFORMATION_MESSAGE WARNING_MESSAGE QUESTION_MESSAGE PLAIN_MESSAGE

		Util.sleep(200);
		
		return(str);
	}
	
}
