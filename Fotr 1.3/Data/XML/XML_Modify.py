import os

#True creates a copy of the xml, False modifies the original
testing = True

#Modify to change the file
xml_folder = 'C:\Program Files (x86)\Steam\steamapps\common\Star Wars Empire at War\corruption\Mods\EmpireatWarExpanded\Data\XML'
xml_file = 'Planets_Three.xml'
multiplier = 1.2

def modify():
	with open('%s\\%s' % (xml_folder, xml_file)) as f:
		content = f.readlines()
	f2 = open('%s\\%s.xml' % (xml_folder, xml_file[:xml_file.find(".")]), 'w')
	for line in content:
		if "Galactic_Position" in line:
			line2 = line[line.find(">")+1::]
			x = line2[:line2.find(",")]
			line3 = line2[line2.find(",")+1::]
			y = line3[:line3.find(",")]
			line4 = line3[line3.find(",")+1::]
			z = line4[:line4.find("<")]

			x = int(float(x) * multiplier)
			y = int(float(y) * multiplier)
			z = int(float(z))
			f2.write("		<Galactic_Position>%s, %s, %s</Galactic_Position> \n" % (x, y, z))
		else:
			f2.write(line)

	if not testing:
		os.remove('%s\\%s' % (xml_folder, xml_file))
		f.close()
		f2.close()
		os.rename('%s\\%s.xml' % (xml_folder, xml_file[:xml_file.find(".")]), '%s\\%s' % (xml_folder, xml_file))

if __name__ == "__main__":
	modify()
