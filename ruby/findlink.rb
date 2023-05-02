
Dir.entries("/sys/class/net").select {|f| !File.file? f}.each { |f| 
	contents = File.open('/sys/class/net/' % f % '/carrier', 'r')
	puts(contents)
}


