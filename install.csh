#!/bin/csh

setenv xroot $PWD
echo $xroot

#### Install Python (and Numerical Python) to XtalEdit/Python/python ###
#wget http://easynews.dl.sourceforge.net/sourceforge/numpy/Numeric-22.0.tar.gz
wget http://superb-west.dl.sourceforge.net/sourceforge/numpy/numpy-1.3.0.tar.gz
wget http://www.python.org/ftp/python/2.5.4/Python-2.5.4.tgz
tar zxvf numpy-1.3.0.tar.gz
tar xfz  Python-2.5.4.tgz
cd Python-2.5.4
./configure --prefix=$xroot/Python
make 
make install

setenv PYTHONHOME $xroot/Python # This is necessary.
cd $xroot/numpy-1.3.0
$xroot/Python/bin/python setup.py install

### Install XtalEdit
xtal:

cd $xroot
wget http://pmt.sakura.ne.jp/XtalEdit/XtalEdit091c.tar.gz
tar zxvf XtalEdit091c.tar.gz
mv XtalEdit/* .
rm -rf XtalEdit

### make script XtalEdit
cat <<EOF >XtalEdit
#!/bin/csh
setenv PATH "$xroot/Python/bin/:\${PATH}"
echo \$PATH
setenv  PYTHONHOME $xroot/Python  # This is necessary.
#xxx/j2re1.4.2_01/bin/java -cp ./classes XtalEdit
java -jar ./XtalEdit.jar
EOF
chmod +x XtalEdit

echo " OK! end of installation of XtalEdit (Python + Numerical Python in addition)"
echo "  You have to install jave from http://java.sum.com/j2se/1.4.2/download.html"
echo "  Then set java path in the script XtalEdit and Run XtalEdit!"
