# Cotala Brochure
This app helps users coming from cotala.com to generate and customize personal PDF files.
# Getting started
- Install Ruby (Version used in this app is 2.6.6)
- Install Rails (Version used in this app is 6.1.4.4)
- Install PostgreSQL.
- Bootstrap 5.1.3
After installing both ruby and ruby on rails:<br/>
1- Clone the project.<br/>
2- Open terminal.<br/>
3- rails db:create<br/>
4- rails db:migrate<br/>
5- rails s

# Edit styling
- You can always edit the css in this general file (app/assets/stylesheets/application.scss).
- Or you can change it just for specific model such as tour.scss.

# Gems used in this app
Gems in Ruby on Rails are like Composer Packages in PHP.<br/>
1- Prawn gem (PDF generation gem)<br/>
https://github.com/prawnpdf/prawn<br/>
2- Faraday gem (HTTP client library)<br/>
https://github.com/lostisland/faraday<br/>
3- Wicked gem (Turns controller into step-by-step)<br/>
https://github.com/zombocom/wicked
