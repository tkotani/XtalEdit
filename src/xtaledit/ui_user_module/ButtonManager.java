package xtaledit.ui_user_module;

import xtaledit.ExecutePython;
import xtaledit.XtalEdit;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Properties;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JToolBar;
import javax.swing.border.TitledBorder;

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
public class ButtonManager {

    private Properties molprop = null;
    private int numPanel = 0;
    private boolean checkTopPanel = false;

    private JPanel buttonTotalPanel = null;
    private JPanel[] buttonpartialPanel = null;
    private JPanel[] buttonPanel = null;
    public JToolBar buttonToolBar = null;

    private XtalEdit frame = null;

    public String[] CategoryList = new String[64];
    public int numList = 0;

    private Properties panel_partialpanel = null;
    private Properties category_panel = null;

    public ButtonManager() {
    }
    public ButtonManager(XtalEdit frame, ArrayList moduleList, Container container) {

        this.frame = frame;
        panel_partialpanel = new Properties();
        category_panel = new Properties();

        // Set Category
        int numCategory = -1;
        int numNext = 0;

        for (int i = 0; i < moduleList.size(); i++) {
            molprop = (Properties)moduleList.get(i);

            String category = molprop.getProperty("ButtonCategory");
            String next = molprop.getProperty("Next");

            boolean flag = categoryFlag(category);

            if (flag == true && next == null) {
                numCategory++;
                category_panel.setProperty(category, String.valueOf(numCategory));
            }
            if (next != null)
                numNext++;

            if (next == null) {
                panel_partialpanel.setProperty(String.valueOf(numCategory), String.valueOf(numNext));
            }
        }

        // Total Button Panel
        buttonTotalPanel = new JPanel(new GridLayout(numNext + 1, 1));
        ((GridLayout)buttonTotalPanel.getLayout()).setVgap(0);

        // Ready need partial panel
        buttonpartialPanel = new JPanel[numNext + 1];
        for (int i = 0; i < numNext + 1; i++) {
            buttonpartialPanel[i] = new JPanel(new FlowLayout());
            buttonTotalPanel.add(buttonpartialPanel[i]);
            ((FlowLayout)buttonpartialPanel[i].getLayout()).setAlignment(FlowLayout.LEFT);
            ((FlowLayout)buttonpartialPanel[i].getLayout()).setHgap(0);
            ((FlowLayout)buttonpartialPanel[i].getLayout()).setVgap(0);
        }

        // Ready need button panel
        buttonPanel = new JPanel[numCategory + 1];
        for (int i = 0; i < numCategory + 1; i++) {
            buttonPanel[i] = new JPanel();
            buttonPanel[i].setBorder(new TitledBorder(CategoryList[i]));
            String panelNum = category_panel.getProperty(CategoryList[i]);
            String rowNum = panel_partialpanel.getProperty(panelNum);
            buttonpartialPanel[Integer.parseInt(rowNum)].add(buttonPanel[i]);
        }

        /*
         *  Set Button and Add to Panel
         */

        for (int i = 0; i < moduleList.size(); i++) {

            // Get Properties
            molprop = (Properties)moduleList.get(i);

            if (molprop.getProperty("ButtonCategory") != null
                && molprop.getProperty("ButtonModule") != null) {
                // Set MenuItem
                SetButton(molprop);
            }
        }

        buttonToolBar = new JToolBar();
        buttonToolBar.add(buttonTotalPanel);

        container.add(buttonToolBar, BorderLayout.SOUTH);
    }

    private boolean categoryFlag(String category) {
        String list = "";
        boolean existflag = false;

        if (category == null) {
            return false;
        }

        for (int i = 0; i < CategoryList.length; i++) {
            list = CategoryList[i];
            if (category.equals(list)) {
                existflag = true;
            }
        }

        if (!existflag) {
            CategoryList[numList] = category;
            numList++;
            return true;
        } else {
            return false;
        }

    }
    private class ButtonAction implements ActionListener {
        String pythonpath = null;
        String modulename = null;
        String arg = null;
        ButtonAction(String pythonpath, String modulename, String arg) {
            this.pythonpath = "./UserModule/" + pythonpath;
            this.modulename = modulename;
            this.arg = arg;
        }
        public void actionPerformed(ActionEvent e) {
            ExecutePython pyObj = new ExecutePython(frame, modulename);
            boolean flag = pyObj.Execute(pythonpath, arg);
            pyObj.showResult(flag, pythonpath);
        }
    }

    public JPanel getPanel() {
        return buttonTotalPanel;
    }
    private void SetButton(Properties prop) {

        // Read from properties
        String Category = prop.getProperty("ButtonCategory");
        String ModuleName = prop.getProperty("ButtonModule");

        String Exe = prop.getProperty("Exe");
        String arg = prop.getProperty("Arg");

        String TextColor = prop.getProperty("TextColor");
        String BackColor = prop.getProperty("BackColor");

        String Next = prop.getProperty("Next");
        String SystemModule = prop.getProperty("System");

        // Default value
        String ExeDef = "./UserModule/System/exe.py";

        // String Check (Set default value if need)
        if (Exe == null)
            Exe = ExeDef;

        // Create Button
        JButton button = new JButton(ModuleName);
        if (SystemModule == null) {
            button.addActionListener(new ButtonAction(Exe, Category, arg));
        } else {
            button.addActionListener(frame.molobj.getSystemMenuItem(prop).getActionListeners()[0]);
        }

        if (BackColor != null) {
            int backcolorNum = Integer.parseInt(BackColor, 16);
            Color backcolor = new Color(backcolorNum);
            button.setBackground(backcolor);
        }
        if (TextColor != null) {
            int textcolorNum = Integer.parseInt(TextColor, 16);
            Color textcolor = new Color(textcolorNum);
            button.setForeground(textcolor);
        }

        int panelnum = Integer.parseInt(category_panel.getProperty(Category));
        buttonPanel[panelnum].add(button);

    }

}
