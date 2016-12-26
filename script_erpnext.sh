echo "Enter the folder name for Setup > "
read text
mkdir $text
cd $text
virtualenv .
source ./bin/activate
echo "Do You Want to install customized bench-repo(y:N)> "
read ans
if [ "$ans" == 'y' ];
then
        echo -n "Enter the bench app path > "
        read bench_path
        git clone -b master $bench_path bench-repo
elif [ "$ans" == 'N' ];
then
        echo "The Master Branch Install By Default....."
        git clone -b master https://github.com/frappe/bench bench-repo
else
        echo "Please enter Correct Input"
fi
pip install -e bench-repo
echo "Do You Want to install customized frappe(y:N)> "
read ans
if [ "$ans" == 'y' ];
then
        echo -n "Enter the frappe app path > "
        read frappe_app_path
        echo "Installing Frappe-bench.........."
        bench init --frappe-path $frappe_app_path frappe-bench
elif [ "$ans" == 'N' ];
then
        bench init --frappe-branch develop frappe-bench
else
        echo "Please enter Correct Input"
fi
cd frappe-bench
source ../bin/activate
echo "Do You Want to install customized erpnext(y:N)> "
read ans
if [ "$ans" == 'y' ];
then
        echo "Enter the erpnext app path > "
        read erpnext_app_path
        bench get-app erpnext $erpnext_app_path
elif [ "$ans" == 'N' ];
then
        bench get-app erpnext --branch master erpnext https://github.com/frappe/erpnext.git
else
        echo "Please enter Correct Input"
fi
echo -n "Enter the Site Name > "
read site_name
bench new-site $site_name
bench install-app erpnext
bench setup nginx
bench setup supervisor
echo -n "Enter the hostname for setting up nginx > "
read nginx_name
sudo ln -s `pwd`/config/nginx.conf /etc/nginx/sites-available/$nginx_name.conf
sudo ln -s /etc/nginx/sites-available/$nginx_name.conf /etc/nginx/sites-enabled/$nginx_name.conf
sudo ln -s `pwd`/config/supervisor.conf /etc/supervisor/conf.d/$nginx_name.conf
sudo supervisorctl reload
sudo service nginx reload
                                  
