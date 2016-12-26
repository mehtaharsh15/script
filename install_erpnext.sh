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
	echo "Installing bench-repo...."
        git clone -b master $bench_path bench-repo
	echo "Installing bench-repo Successfully...."
elif [ "$ans" == 'N' ];
then
        echo "The Master Branch Installing By Default....."
        git clone -b master https://github.com/frappe/bench bench-repo
	echo "Installing bench-repo Successfully....."
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
	echo "Frappe app installed Successfully...."
elif [ "$ans" == 'N' ];
then
	echo "Installing Frappe-bench of master branch.........."        
	bench init --frappe-branch master frappe-bench
	echo "Frappe app installed Successfully...."
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
	echo "Installing Erpnext.........."        
	bench get-app erpnext $erpnext_app_path
	echo "Installing Erpnext Successfully.........."   
elif [ "$ans" == 'N' ];
then
	echo "Installing Erpnext of master branch.........."        
        bench get-app erpnext --branch master erpnext https://github.com/frappe/erpnext.git
	echo "Installing Erpnext Successfully.........."        
else
        echo "Please enter Correct Input"
fi
echo "Do You Want to install customized app(y:N)> "
read ans
if [ "$ans" == 'y' ];
then
	echo "Enter the customized app Name > "
        read custom_app_name        
	echo "Enter the customized app path > "
        read custom_app_path
        bench get-app $custom_app_name $custom_app_path
	echo "$custom_app_name installed Successfully....."
elif [ "$ans" == 'N' ];
then
        echo " Not any Custom app install in the Cureent Site "
else
        echo "Please enter Correct Input"
fi
echo -n "Enter the Site Name > "
read site_name
echo "Installing Site.........."        
bench new-site $site_name
echo "Do You Want to installing the erpnext app in your site(y:N)> "
read ans
if [ "$ans" == 'y' ];
then
        echo "Enter the erpnext app path > "
        bench install-app erpnext
	echo "Erpnext app installed Successfully in your site...."
elif [ "$ans" == 'N' ];
then
        echo "Erpnext Not install in your Site "
else
        echo "Please enter Correct Input"
fi
bench setup nginx
bench setup supervisor
echo -n "Enter the hostname(Domain Name) for setting up nginx > "
read nginx_name
sudo ln -s `pwd`/config/nginx.conf /etc/nginx/sites-available/$nginx_name.conf
sudo ln -s /etc/nginx/sites-available/$nginx_name.conf /etc/nginx/sites-enabled/$nginx_name.conf
sudo ln -s `pwd`/config/supervisor.conf /etc/supervisor/conf.d/$nginx_name.conf
sudo supervisorctl reload
sudo service nginx reload
                                  
