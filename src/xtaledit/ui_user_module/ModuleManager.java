package xtaledit.ui_user_module;

import xtaledit.XtalEdit;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.NoSuchElementException;
import java.util.Properties;
import java.util.StringTokenizer;

import javax.swing.JCheckBoxMenuItem;
import javax.swing.JMenuItem;

/*
 * Created on 2003/07/29
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
public class ModuleManager {

    String confText = null;
    ArrayList moduleList = null;
    private Properties molprop = null;
    private XtalEdit frame = null;

    public ModuleManager(XtalEdit frame) {

        this.frame = frame;
        // Open User Configuration File
        File confFile = new File("./userset.conf");
        if (confFile.exists()) {
            confText = removeComment(confFile);
            confText = removeLF(confText);
            moduleList = moduleInfo(confText);
        }
    }

    /*
     *  Method
     */

    private String removeComment(File confFile) {
        String str = "";
        try {
            FileReader fr = new FileReader(confFile);
            BufferedReader bufferR = new BufferedReader(fr);
            String tempstr;
            while ((tempstr = bufferR.readLine()) != null) {
                tempstr = tempstr.trim();
                if (!tempstr.startsWith("#"))
                    str = str + tempstr;
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return str;
    }
    private String removeLF(String confText) {
        String output = "";
        for (int i = 0; i < confText.length() - 1; i++) {
            String substr = confText.substring(i, i + 1);
            if (!substr.equals("\n") && !substr.equals("\r"))
                output = output + substr;
        }
        return output;
    }
    private ArrayList moduleInfo(String str) {
        Properties prop = null;
        ArrayList moduleList = new ArrayList();
        StringTokenizer stoken = new StringTokenizer(str, "{}");
        while (stoken.hasMoreTokens()) {
            // 1 Module Info
            prop = new Properties();
            String str2 = stoken.nextToken();
            StringTokenizer stoken2 = new StringTokenizer(str2, ",");
            while (stoken2.hasMoreTokens()) {
                // 1 Function Info
                String str3 = stoken2.nextToken();
                StringTokenizer stoken3 = new StringTokenizer(str3, ":");
                while (stoken3.hasMoreTokens()) {
                    String function = "";
                    String infomation = "";
                    // Function vs. Infomation
                    function = stoken3.nextToken();
                    function = function.trim();
                    function = function.substring(1, function.length() - 1);

                    if (function.equals("Next")) {
                        infomation = "TRUE";
                    } else {
                        infomation = stoken3.nextToken();
                        infomation = infomation.trim();
                        infomation = infomation.substring(1, infomation.length() - 1);
                    }

                    if (function.equals("Menu")) {
                        setMenu(prop, infomation);
                    } else if (function.equals("Button")) {
                        setButton(prop, infomation);
                    } else {
                        prop.setProperty(function, infomation);
                    }

                }
            }
            moduleList.add(prop);
            if(prop.getProperty("System")!=null && prop.getProperty("System").equals("Title")){
                XtalEdit.titlename = prop.getProperty("Arg");
                frame.SetTitleName();
            }
            
            
        }
        return moduleList;
    }
    private void setMenu(Properties prop, String info) {
        StringTokenizer menustoken = new StringTokenizer(info, "@");
        String Title = menustoken.nextToken();
        Title = Title.trim();
        String Category = menustoken.nextToken();
        Category = Category.trim();
        prop.setProperty("MenuTitle", Title);
        prop.setProperty("MenuCategory", Category);

        String ModuleName = null;
        try {
            ModuleName = menustoken.nextToken();
            ModuleName = ModuleName.trim();
            prop.setProperty("MenuModule", ModuleName);
        } catch (NoSuchElementException e) {
        }

    }
    private void setButton(Properties prop, String info) {
        StringTokenizer menustoken = new StringTokenizer(info, "@");
        String Category = menustoken.nextToken();
        Category = Category.trim();
        String ModuleName = menustoken.nextToken();
        ModuleName = ModuleName.trim();

        prop.setProperty("ButtonCategory", Category);
        prop.setProperty("ButtonModule", ModuleName);
    }
    public ArrayList getmoduleArray() {
        return moduleList;
    }

    public JMenuItem getSystemMenuItem(Properties prop) {

        String SystemModule = prop.getProperty("System");
        String path = prop.getProperty("Arg");

        JMenuItem menuitem = null;
        JCheckBoxMenuItem checkbox = null;

        // Create MenuItem
        if (SystemModule.equals("Divide")){
            frame.division.setName(SystemModule);
            return frame.division;
        }else if(SystemModule.equals("EditIcon")){
            frame.editiconMenu.setName(SystemModule);
            return frame.editiconMenu;
        }else if(SystemModule.equals("ResultIcon")){
            frame.logiconMenu.setName(SystemModule);
            return frame.logiconMenu;
        }else if(SystemModule.equals("ButtonPanel")) {
            frame.buttonMenu.setName(SystemModule);
            return frame.buttonMenu;
        }else if(SystemModule.equals("View")){
            String Category = prop.getProperty("MenuCategory");
            String Module = prop.getProperty("MenuModule");
            if(Module == null){
                Module = Category;
            }
            menuitem = new JMenuItem(Category);
            menuitem.addActionListener(frame.new ViewCommand(XtalEdit.UserModuleDir+path));
            return menuitem;
        } else {
            menuitem = new JMenuItem(SystemModule);

            if (SystemModule.equals("Undo")) {
                menuitem.addActionListener(frame.new UndoCommand());
            } else if (SystemModule.equals("Redo")) {
                menuitem.addActionListener(frame.new RedoCommand());
            } else if (SystemModule.equals("History")) {
                menuitem.addActionListener(frame.hist);
            } else if (SystemModule.equals("RunPython")) {
                menuitem.addActionListener(frame.new RunPYTHONCommand());
            } else if (SystemModule.equals("Font")) {
                menuitem.addActionListener(frame.fontlistener);
            } else if (SystemModule.equals("Open")) {
                menuitem.addActionListener(frame.new OpenCommand());
            } else if (SystemModule.equals("EditSave")) {
                menuitem.addActionListener(frame.new SaveCommand(frame.editArea, false));
            } else if (SystemModule.equals("EditSaveAS")) {
                menuitem.addActionListener(frame.new SaveCommand(frame.editArea, true));
            } else if (SystemModule.equals("EditSaveAS")) {
                menuitem.addActionListener(frame.new SaveCommand(frame.editArea, true));
            } else if (SystemModule.equals("ResultSave")) {
                menuitem.addActionListener(frame.new SaveCommand(frame.logArea, false));
            } else if (SystemModule.equals("ResultSaveAS")) {
                menuitem.addActionListener(frame.new SaveCommand(frame.logArea, true));
            } else if (SystemModule.equals("Exit")) {
                menuitem.addActionListener(frame.new ExitCommand());
            } else if (SystemModule.equals("EditClear")) {
                menuitem.addActionListener(frame.new TextAreaClearCommand(frame.editArea));
            } else if (SystemModule.equals("ResultClear")) {
                menuitem.addActionListener(frame.new TextAreaClearCommand(frame.logArea));
            } 

            return menuitem;
        }
    }

}
