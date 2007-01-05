rdoc:
	rdoc --op rdoc escape.rb

README:
	erb misc/README.erb > README
