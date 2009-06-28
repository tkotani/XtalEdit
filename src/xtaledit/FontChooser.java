package xtaledit;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Frame;
import java.awt.GraphicsEnvironment;
import java.awt.Point;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.StringTokenizer;

import javax.swing.DefaultListModel;
import javax.swing.JDialog;
import javax.swing.JList;


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

public class FontChooser extends javax.swing.JDialog {
	private final static boolean DBG = false; // DBG_CHANGE

	String[] styleList = new String[] { "Plain", "Bold", "Italic" };
	String[] sizeList =
		new String[] {
			"2",
			"4",
			"6",
			"8",
			"10",
			"12",
			"14",
			"16",
			"18",
			"20",
			"22",
			"24",
			"30",
			"36",
			"48",
			"72" };

	String currentName = null;
	int currentStyle = -1;
	int currentSize = -1;

	public boolean ok = false;

	String SAMPTEXT =
		"0123456789/*+-.:;(){}[]!\"\'#$%&\\"
			+ "\n"
			+ "abcdefghijklmnopqrstuvwxyz"
			+ "\n"
			+ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			+ "\n"
			+ "Live as if you were to die tomorrow. Learn as if you were to live forever.";

	//Font DEFAULTFONT = new java.awt.Font("Monospaced", 0, 12);
	private javax.swing.JPanel FonPanel;
	private javax.swing.JTextField FontTxt;
	private javax.swing.JScrollPane FonScrollPane;
	private javax.swing.JList FontList;

	private javax.swing.JPanel StylePanel;
	private javax.swing.JTextField StyleTxt;
	private javax.swing.JScrollPane StyleScrollPane;
	private javax.swing.JList StyleList;

	private javax.swing.JPanel SizePanel;
	private javax.swing.JTextField SizeTxt;
	private javax.swing.JScrollPane SizeScrollPane;
	private javax.swing.JList SizeList;

	private javax.swing.JPanel SamplePanel;
	private javax.swing.JScrollPane SampleScrollPane;
	private javax.swing.JTextArea SampleTxar;

	private javax.swing.JPanel ButtonsPanel;
	private javax.swing.JButton Btn_Ok;
	private javax.swing.JButton Btn_Cancel;
	private javax.swing.JLabel BtnLabel;

	/**
	 * Constructor
	 * @param parent
	 * @param modal
	 * @param title
	 * @param font
	 */
	FontChooser(Frame parent, boolean modal, String title, Font font) {
		super(parent, modal);
		initComponents();

		SamplePanel.setMinimumSize(new Dimension(200, 200));
		SamplePanel.setMaximumSize(new Dimension(200, 1000));

		setListValues(
			FontList,
			GraphicsEnvironment
				.getLocalGraphicsEnvironment()
				.getAvailableFontFamilyNames());
		setListValues(StyleList, styleList);
		setListValues(SizeList, sizeList);

		setInitFont(font); // DEFAULTFONT
		if (DBG)
			MsgManager.print(this, "(FontChooserUI) " + SampleTxar.getFont());

		pack();

		if (title != null)
			setTitle(title);

		//setResizable(false);
		setSize(new java.awt.Dimension(400, 600));
		setDialogPos(parent, this);

		// for available default button init disp (
		addWinListener();
		//transferFocus();
		//requestFocus(); <- must after visible!
		//FontList  Btn_Ok

		show(); //xx setVisible(true);
	}
	/**
	*  Set dialog pos
	*/
	private static void setDialogPos(Frame parent, JDialog dialog) {
		Point p1 = parent.getLocation();
		Dimension d1 = parent.getSize();

		Dimension d2 = dialog.getSize();

		int x = p1.x + (d1.width - d2.width) / 2;
		int y = p1.y + (d1.height - d2.height) / 2;

		if (x < 0) {
			x = 0;
		}
		if (y < 0) {
			y = 0;
		}

		dialog.setLocation(x, y);

	}

	/**
	*  Closes the dialog
	*/
	private void closeDialog(java.awt.event.WindowEvent evt) {
		setVisible(false);
	}

	/**
	*  add Window Listener
	*/
	private void addWinListener() {
		this.addWindowListener(new WindowAdapter() {
			public void windowOpened(WindowEvent e) {
				if (e.getID() == WindowEvent.WINDOW_OPENED)
					FontList.requestFocus(); // Btn_Ok is OUT?
			}
		});
	}

	/**
	  *  set List val
	  */
	private void setListValues(JList list, String[] values) {
		if (list.getModel() instanceof DefaultListModel) {
			DefaultListModel model = (DefaultListModel) list.getModel();
			model.removeAllElements();
			for (int i = 0; i < values.length; i++) {
				//model.addElement(values);
				model.addElement(values[i]);
			}
		}
	}

	/**
	  *  set Init Font info (3-text area & Sample Text)
	  */
	private void setInitFont(Font font) {
		if (font == null)
			return;

		FontTxt.setText(font.getName());
		StyleTxt.setText(styleToString(font.getStyle()));
		SizeTxt.setText(Integer.toString(font.getSize()));

		//must after Upper set
		int idx;
		FontList.setSelectedValue(FontTxt.getText(), true);
		// ??
		//idx = FontList.getSelectedIndex();
		//if(idx >=0) FontList.ensureIndexIsVisible(idx);
		StyleList.setSelectedValue(StyleTxt.getText(), true);
		SizeList.setSelectedValue(SizeTxt.getText(), true);
		setSampleFont();
		/*
		FontTxtActionPerformed(null);  // set currentName & set SampleText
		StyleTxtActionPerformed(null); //     ditto
		SizeTxtActionPerformed(null);  //     ditto
		*/
	}

	/**
	*  set Sample Text
	*/
	private void setSampleFont() {
		if (currentName != null && currentStyle >= 0 && currentSize > 0) {
			SampleTxar.setFont(
				new Font(currentName, currentStyle, currentSize));

			refreshSampleFont(); // if None , Text between-len ?
			//SampleTxar.setText(SAMPTEXT);  
			SampleTxar.setCaretPosition(0);
		}
	}

	private void refreshSampleFont() {
		//SampleTxar.setColumns(30);  // old 20
		//SampleTxar.setRows(3);  //  old 3
		String str = SampleTxar.getText();
		if (str == null || str.length() == 0)
			str = SAMPTEXT;
		SampleTxar.setText(str);
		SampleScrollPane.setViewportView(SampleTxar);
		//SampleScrollPane.getViewport().add(SampleTxar);
	}

	/**
	*  style to String Util
	*/
	private String styleToString(int style) {
		String str = "";
		if ((style & Font.BOLD) == Font.BOLD) {
			if (str.length() > 0) {
				str += ",";
			}
			str += "Bold";
		}
		if ((style & Font.ITALIC) == Font.ITALIC) {
			if (str.length() > 0) {
				str += ",";
			}
			str += "Italic";
		}
		if (str.length() <= 0 && (style & Font.PLAIN) == Font.PLAIN) {
			str = "Plain";
		}
		return str;
	}

	/**
	* Init Comp
	*/
	private void initComponents() {
		FonPanel = new javax.swing.JPanel();
		FontTxt = new javax.swing.JTextField();
		FonScrollPane = new javax.swing.JScrollPane();
		FontList = new javax.swing.JList();

		StylePanel = new javax.swing.JPanel();
		StyleTxt = new javax.swing.JTextField();
		StyleScrollPane = new javax.swing.JScrollPane();
		StyleList = new javax.swing.JList();

		SizePanel = new javax.swing.JPanel();
		SizeTxt = new javax.swing.JTextField();
		SizeScrollPane = new javax.swing.JScrollPane();
		SizeList = new javax.swing.JList();

		SamplePanel = new javax.swing.JPanel();
		SampleScrollPane = new javax.swing.JScrollPane();
		SampleTxar = new javax.swing.JTextArea();

		ButtonsPanel = new javax.swing.JPanel();
		Btn_Ok = new javax.swing.JButton();
		Btn_Cancel = new javax.swing.JButton();
		BtnLabel = new javax.swing.JLabel();

		rootPane.setDefaultButton(Btn_Ok);
		//getRootPane().setDefaultButton(Btn_Ok);

		getContentPane().setLayout(new java.awt.GridBagLayout());
		java.awt.GridBagConstraints gbc1;

		//---
		FontTxt.setEditable(false);
		StyleTxt.setEditable(false);
		SizeTxt.setEditable(false);
		SampleTxar.setEditable(true);
		//---

		setTitle("Font Chooser");

		addWindowListener(new java.awt.event.WindowAdapter() {
			public void windowClosing(java.awt.event.WindowEvent evt) {
				closeDialog(evt);
			}
		});

		//----------
		FonPanel.setLayout(new java.awt.GridBagLayout());
		java.awt.GridBagConstraints gbc2;
		FonPanel.setBorder(
			new javax.swing.border.TitledBorder(
				new javax.swing.border.EtchedBorder(),
				" Font "));

		FontTxt.setColumns(24);
		FontTxt.addActionListener(new java.awt.event.ActionListener() {
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				FontTxtActionPerformed(evt);
			}
		});
		gbc2 = new java.awt.GridBagConstraints();
		gbc2.gridwidth = 0;
		gbc2.fill = java.awt.GridBagConstraints.HORIZONTAL;
		gbc2.insets = new java.awt.Insets(0, 3, 0, 3);
		gbc2.anchor = java.awt.GridBagConstraints.NORTHWEST;
		gbc2.weightx = 1.0;
		FonPanel.add(FontTxt, gbc2);

		FontList.setModel(new DefaultListModel());
		FontList.setSelectionMode(
			javax.swing.ListSelectionModel.SINGLE_SELECTION);
		FontList
			.addListSelectionListener(
				new javax
				.swing
				.event
				.ListSelectionListener() {
			public void valueChanged(
				javax.swing.event.ListSelectionEvent evt) {
				FontListValueChanged(evt);
			}
		});
		FonScrollPane.setViewportView(FontList);

		gbc2 = new java.awt.GridBagConstraints();
		gbc2.fill = java.awt.GridBagConstraints.BOTH;
		gbc2.insets = new java.awt.Insets(3, 3, 3, 3);
		gbc2.anchor = java.awt.GridBagConstraints.NORTHWEST;
		gbc2.weightx = 1.0;
		gbc2.weighty = 1.0;
		FonPanel.add(FonScrollPane, gbc2);

		gbc1 = new java.awt.GridBagConstraints();
		gbc1.fill = java.awt.GridBagConstraints.BOTH;
		gbc1.insets = new java.awt.Insets(5, 5, 0, 0);
		gbc1.weightx = 0.5;
		gbc1.weighty = 1.0;
		getContentPane().add(FonPanel, gbc1);

		//----------
		StylePanel.setLayout(new java.awt.GridBagLayout());
		java.awt.GridBagConstraints gbc3;
		StylePanel.setBorder(
			new javax.swing.border.TitledBorder(
				new javax.swing.border.EtchedBorder(),
				" Style "));

		StyleTxt.setColumns(18);
		StyleTxt.addActionListener(new java.awt.event.ActionListener() {
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				StyleTxtActionPerformed(evt);
			}
		});
		gbc3 = new java.awt.GridBagConstraints();
		gbc3.gridwidth = 0;
		gbc3.fill = java.awt.GridBagConstraints.HORIZONTAL;
		gbc3.insets = new java.awt.Insets(0, 3, 0, 3);
		gbc3.anchor = java.awt.GridBagConstraints.NORTHWEST;
		gbc3.weightx = 1.0;
		StylePanel.add(StyleTxt, gbc3);

		StyleList.setModel(new DefaultListModel());
		StyleList.setVisibleRowCount(4);
		StyleList
			.addListSelectionListener(
				new javax
				.swing
				.event
				.ListSelectionListener() {
			public void valueChanged(
				javax.swing.event.ListSelectionEvent evt) {
				StyleListValueChanged(evt);
			}
		});
		StyleScrollPane.setViewportView(StyleList);

		gbc3 = new java.awt.GridBagConstraints();
		gbc3.fill = java.awt.GridBagConstraints.BOTH;
		gbc3.insets = new java.awt.Insets(3, 3, 3, 3);
		gbc3.anchor = java.awt.GridBagConstraints.NORTHWEST;
		gbc3.weightx = 0.5;
		gbc3.weighty = 1.0;
		StylePanel.add(StyleScrollPane, gbc3);

		gbc1 = new java.awt.GridBagConstraints();
		gbc1.fill = java.awt.GridBagConstraints.BOTH;
		gbc1.insets = new java.awt.Insets(5, 5, 0, 0);
		gbc1.weightx = 0.375;
		gbc1.weighty = 1.0;
		getContentPane().add(StylePanel, gbc1);

		//----------
		SizePanel.setLayout(new java.awt.GridBagLayout());
		java.awt.GridBagConstraints gbc4;
		SizePanel.setBorder(
			new javax.swing.border.TitledBorder(
				new javax.swing.border.EtchedBorder(),
				" Size "));

		SizeTxt.setColumns(6);
		SizeTxt.addActionListener(new java.awt.event.ActionListener() {
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				SizeTxtActionPerformed(evt);
			}
		});
		gbc4 = new java.awt.GridBagConstraints();
		gbc4.gridwidth = 0;
		gbc4.fill = java.awt.GridBagConstraints.HORIZONTAL;
		gbc4.insets = new java.awt.Insets(0, 3, 0, 3);
		gbc4.anchor = java.awt.GridBagConstraints.NORTHWEST;
		gbc4.weightx = 1.0;
		SizePanel.add(SizeTxt, gbc4);

		SizeList.setModel(new DefaultListModel());
		SizeList.setVisibleRowCount(4);
		SizeList.setSelectionMode(
			javax.swing.ListSelectionModel.SINGLE_SELECTION);
		SizeList
			.addListSelectionListener(
				new javax
				.swing
				.event
				.ListSelectionListener() {
			public void valueChanged(
				javax.swing.event.ListSelectionEvent evt) {
				SizeListValueChanged(evt);
			}
		});
		SizeScrollPane.setViewportView(SizeList);

		gbc4 = new java.awt.GridBagConstraints();
		gbc4.fill = java.awt.GridBagConstraints.BOTH;
		gbc4.insets = new java.awt.Insets(3, 3, 3, 3);
		gbc4.anchor = java.awt.GridBagConstraints.NORTHWEST;
		gbc4.weightx = 0.25;
		gbc4.weighty = 1.0;
		SizePanel.add(SizeScrollPane, gbc4);

		gbc1 = new java.awt.GridBagConstraints();
		gbc1.gridwidth = 0;
		gbc1.fill = java.awt.GridBagConstraints.BOTH;
		gbc1.insets = new java.awt.Insets(5, 5, 0, 5);
		gbc1.weightx = 0.125;
		gbc1.weighty = 1.0;
		getContentPane().add(SizePanel, gbc1);

		//----------
		SamplePanel.setLayout(new java.awt.GridBagLayout());
		java.awt.GridBagConstraints gbc5;
		SamplePanel.setBorder(
			new javax.swing.border.TitledBorder(
				new javax.swing.border.EtchedBorder(),
				" Sample Text"));

		//SampleTxar.setWrapStyleWord(true);
		//SampleTxar.setLineWrap(true);  // false -> (Vert-slider)
		//SampleTxar.setFont(DEFAULTFONT);  // dummy for Next Size
		refreshSampleFont(); // SUB

		gbc5 = new java.awt.GridBagConstraints();
		gbc5.fill = java.awt.GridBagConstraints.BOTH;
		gbc5.insets = new java.awt.Insets(0, 3, 3, 3);
		gbc5.weightx = 1.0;
		gbc5.weighty = 1.0;
		SamplePanel.add(SampleScrollPane, gbc5);

		gbc1 = new java.awt.GridBagConstraints();
		gbc1.gridwidth = 0;
		gbc1.fill = java.awt.GridBagConstraints.BOTH;
		gbc1.insets = new java.awt.Insets(0, 5, 0, 5);
		gbc1.anchor = java.awt.GridBagConstraints.NORTHWEST;
		gbc1.weightx = 1.0;
		gbc1.weighty = 0.0; // add
		getContentPane().add(SamplePanel, gbc1);

		//----------
		ButtonsPanel.setLayout(new java.awt.GridBagLayout());
		java.awt.GridBagConstraints gbc6;

		//////
		//Btn_Cancel.setMnemonic(KeyEvent.VK_C);
		Btn_Cancel.setText("Cancel");
		Btn_Cancel.setRequestFocusEnabled(false);
		Btn_Cancel.addActionListener(new java.awt.event.ActionListener() {
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				Btn_CancelActionPerformed(evt);
			}
		});
		gbc6 = new java.awt.GridBagConstraints();
		//gbc6.gridwidth = 0;
		gbc6.insets = new java.awt.Insets(5, 5, 5, 5);
		gbc6.anchor = java.awt.GridBagConstraints.EAST; //  WEST
		//gbc6.weightx = 1.0;
		ButtonsPanel.add(Btn_Cancel, gbc6);

		//Btn_Ok.setMnemonic(KeyEvent.VK_O);
		Btn_Ok.setText("OK");
		Btn_Ok.setRequestFocusEnabled(false);
		Btn_Ok.addActionListener(new java.awt.event.ActionListener() {
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				Btn_OkActionPerformed(evt);
			}
		});
		gbc6 = new java.awt.GridBagConstraints();
		gbc6.gridwidth = 0; // 
		gbc6.insets = new java.awt.Insets(5, 5, 5, 0);
		gbc6.anchor = java.awt.GridBagConstraints.EAST; // WEST
		gbc6.weightx = 1.0; // 
		ButtonsPanel.add(Btn_Ok, gbc6);
		//////

		gbc6 = new java.awt.GridBagConstraints();
		gbc6.weightx = 1.0;
		ButtonsPanel.add(BtnLabel, gbc6);

		gbc1 = new java.awt.GridBagConstraints();
		gbc1.gridwidth = 0;
		gbc1.anchor = java.awt.GridBagConstraints.SOUTHEAST; // SOUTHWEST;
		gbc1.weightx = 1.0;
		getContentPane().add(ButtonsPanel, gbc1);

	}

	/**
	*   proc
	*/
	private void Btn_CancelActionPerformed(java.awt.event.ActionEvent evt) {
		setVisible(false);
	}

	private void Btn_OkActionPerformed(java.awt.event.ActionEvent evt) {
		ok = true;
		setVisible(false);
	}

	//	/
	private void SizeTxtActionPerformed(java.awt.event.ActionEvent evt) {
		int size = 0;
		try {
			size = Integer.parseInt(SizeTxt.getText());
		} catch (Exception e) {
		}
		if (size > 0) {
			currentSize = size;
			setSampleFont();
		}
	}

	private void StyleTxtActionPerformed(java.awt.event.ActionEvent evt) {
		StringTokenizer st = new StringTokenizer(StyleTxt.getText(), ",");
		int style = 0;
		while (st.hasMoreTokens()) {
			String str = st.nextToken().trim();
			if (str.equalsIgnoreCase("Plain")) {
				style |= Font.PLAIN;
			} else if (str.equalsIgnoreCase("Bold")) {
				style |= Font.BOLD;
			} else if (str.equalsIgnoreCase("Italic")) {
				style |= Font.ITALIC;
			}
		}
		if (style >= 0) {
			currentStyle = style;
			setSampleFont();
		}
	}
	
	private void FontTxtActionPerformed (java.awt.event.ActionEvent evt) {
		DefaultListModel model = (DefaultListModel)
		FontList.getModel();
		if (model.indexOf(FontTxt.getText()) >= 0) {
			currentName = FontTxt.getText();
			setSampleFont();
		}
	}
	
	///
	private void StyleListValueChanged(
		javax.swing.event.ListSelectionEvent evt) {
		String str = new String();
		Object[] values = StyleList.getSelectedValues();
		//String[] values = (String[])StyleList.getSelectedValues();  // chg
		if (values.length > 0) {
			int i;
			for (i = 0; i < values.length; i++) {
				//String s = (String) values;
				String s = values[i].toString(); //  chg
				if (s.equalsIgnoreCase("Plain")) {
					str = "Plain";
					break;
				}
				if (str.length() > 0) {
					str += ",";
				}
				//str += (String) values;
				str += values[i].toString(); //  chg
			}
		} else {
			str = styleToString(currentStyle);
		}

		StyleTxt.setText(str);
		StyleTxtActionPerformed(null);
	}

	private void SizeListValueChanged(
		javax.swing.event.ListSelectionEvent evt) {
		String str = (String) SizeList.getSelectedValue();
		if (str == null || str.length() <= 0) {
			str = Integer.toString(currentSize);
		}
		SizeTxt.setText(str);
		SizeTxtActionPerformed(null);
	}

	private void FontListValueChanged(
		javax.swing.event.ListSelectionEvent evt) {
		String str = (String) FontList.getSelectedValue();
		if (str == null || str.length() <= 0) {
			str = currentName;
		}
		FontTxt.setText(str);
		FontTxtActionPerformed(null);
	}
	
	/**
	* get CurrentFont
	*/
	public Font getCurrentFont() {
		return SampleTxar.getFont();
	}


}
