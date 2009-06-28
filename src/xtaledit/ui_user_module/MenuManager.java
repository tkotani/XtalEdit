package xtaledit.ui_user_module;

import xtaledit.XtalEdit;
import xtaledit.ExecutePython;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Properties;

import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

/*
 * Created on 2003/07/31
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */

/**
 * @author Sora Takefumi
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class MenuManager {

    Properties molprop = null;
    int numPanel = 0;
    boolean checkTopPanel = false;

    private static final int MENU_MAX = 16;
    private JMenu[] menuList = null;
    private boolean NEWMenu_Flag = false;
    private int numMenu = 0;
    private Properties menu_number = null;

    private static final int CATEGORY_MAX = 64;
    private JMenu[] categoryMenuList = null;
    private String[] categoryNameList = null;
    private boolean NEWCategory_Flag = false;
    private int numCategory = 0;
    private Properties category_number = null;

    JMenu title = null;
    JMenu categoryM = null;
    JMenuItem moduleMI = null;

    private XtalEdit frame = null;

    public MenuManager() {
    }
    public MenuManager(XtalEdit frame, ArrayList moduleList, JMenuBar jmb) {

        this.frame = frame;

        /*
         *  Regist Top Menu Info
         */
        menuList = new JMenu[MENU_MAX];
        menu_number = new Properties();
        for (int i = 0; i < moduleList.size(); i++) {
            // Get Properties
            molprop = (Properties)moduleList.get(i);
            String menuName = molprop.getProperty("MenuTitle");
            NEWMenu_Flag = true;
            if (menuName != null) {
                for (int j = 0; j < numMenu; j++) {
                    String name = menuList[j].getText();
                    if (name.equals(menuName)) {
                        NEWMenu_Flag = false;
                    }
                }
                if (NEWMenu_Flag) {
                    menuList[numMenu] = new JMenu(menuName);
                    menuList[numMenu].setMnemonic(menuName.charAt(0));
                    jmb.add(menuList[numMenu]);
                    menu_number.setProperty(menuName, String.valueOf(numMenu));
                    numMenu++;
                }
            }
        }

        /*
         *  Regist Category Menu
         */
        categoryMenuList = new JMenu[MENU_MAX];
        category_number = new Properties();
        for (int i = 0; i < moduleList.size(); i++) {
            // Get Properties
            molprop = (Properties)moduleList.get(i);
            String categoryName = molprop.getProperty("MenuCategory");
            String moduleName = molprop.getProperty("MenuModule");

            NEWCategory_Flag = true;
            if (categoryName != null && moduleName != null) {
                for (int j = 0; j < numCategory; j++) {
                    String name = categoryMenuList[j].getText();
                    if (name.equals(categoryName)) {
                        NEWCategory_Flag = false;
                    }
                }
                if (NEWCategory_Flag) {
                    categoryMenuList[numCategory] = new JMenu(categoryName);
                    categoryMenuList[numCategory].setMnemonic(categoryName.charAt(0));
                    category_number.setProperty(categoryName, String.valueOf(numCategory));
                    numCategory++;
                }
            }
        }

        /*
         *  Create and Add
         */

        categoryNameList = new String[CATEGORY_MAX];
        for (int i = 0; i < moduleList.size(); i++) {

            // Get Properties
            molprop = (Properties)moduleList.get(i);

            if (molprop.getProperty("MenuTitle") != null && molprop.getProperty("MenuCategory") != null) {

                String Title = molprop.getProperty("MenuTitle");
                String Category = molprop.getProperty("MenuCategory");
                String Module = molprop.getProperty("MenuModule");

                SetMenuItem(molprop);

            }
        }
    }

    private class MenuAction implements ActionListener {
        String helppath = null;
        String pythonpath = null;
        String modulename = null;
        String arg = null;
        MenuAction(String pythonpath, String modulename, String arg) {
            this.pythonpath = "./UserModule/" + pythonpath;
            this.modulename = modulename;
            this.arg = arg;
        }
        public void actionPerformed(ActionEvent e) {
            // Create xxx.csy and execute python module file
            ExecutePython pyObj = new ExecutePython(frame, modulename);
            boolean flag = pyObj.Execute(pythonpath, arg);
            pyObj.showResult(flag, pythonpath);
        }
    }

    private void SetMenuItem(Properties prop) {

        // Default
        // String Set
        String Title = prop.getProperty("MenuTitle");
        String Category = prop.getProperty("MenuCategory");
        String ModuleName = prop.getProperty("MenuModule");

        String Exe = prop.getProperty("Exe");
        String Arg = prop.getProperty("Arg");
        // Default value
        String ExeDef = "./UserModule/System/exe.py";
        String HelpDef = "./UserModule/System/help.txt";

        // String Check (Set default value if need)
        if (Exe == null)
            Exe = ExeDef;

        if (Category != null && ModuleName != null) {
            boolean check = categoryCheck(Category);
            if (!check) {
                // Get Title Menu
                String titleindex = menu_number.getProperty(Title);

                // Create New Category
                String categoryIndex = category_number.getProperty(Category);
                menuList[Integer.parseInt(titleindex)].add(categoryMenuList[Integer.parseInt(categoryIndex)]);

                // Create New MenuItem
                JMenuItem moduleMI = null;
                if(prop.getProperty("System")==null){
                    moduleMI = new JMenuItem(ModuleName);
                    moduleMI.addActionListener(new MenuAction(Exe, ModuleName, Arg));
                }else{
                    moduleMI = frame.molobj.getSystemMenuItem(prop);
                }
                categoryMenuList[Integer.parseInt(categoryIndex)].add(moduleMI);
            } else {
                // Get Category
                String categoryIndex = category_number.getProperty(Category);

                // Create New MenuItem
                JMenuItem moduleMI = null;
                if(prop.getProperty("System")==null){
                    moduleMI = new JMenuItem(ModuleName);
                    moduleMI.addActionListener(new MenuAction(Exe, ModuleName, Arg));
                }else{
                    moduleMI = frame.molobj.getSystemMenuItem(prop);
                }

                moduleMI.setMnemonic(moduleMI.getText().charAt(0));
                categoryMenuList[Integer.parseInt(categoryIndex)].add(moduleMI);
            }
        } else if (Category != null && ModuleName == null) {
            // Get Title Menu
            String titleindex = menu_number.getProperty(Title);

            // Create New MenuItem
            JMenuItem moduleMI = null;
            if(prop.getProperty("System")==null){
                moduleMI = new JMenuItem(Category);
                moduleMI.addActionListener(new MenuAction(Exe, Category, Arg));
            }else{
                moduleMI = frame.molobj.getSystemMenuItem(prop);
            }
            
            moduleMI.setMnemonic(moduleMI.getText().charAt(0));
            menuList[Integer.parseInt(titleindex)].add(moduleMI);
        }

    }
    private boolean categoryCheck(String category) {
        String name = null;
        for (int i = 0; i < categoryNameList.length; i++) {
            name = categoryNameList[i];
            if (name == null) {
                break;
            } else if (name.equals(category)) {
                return true;
            }
        }
        return false;
    }

}
