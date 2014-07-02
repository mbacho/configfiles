#!/usr/bin/env python

"""
Create animated slideshow backgrounds

bgmaker readme
1) Get pics from folder / image-file argument array
2) Create bg xml file with absolute paths
3) Get bg_name n save the xml file
4) Change desktop bg to the xml file

for xml template look at /usr/share/bg/cosmos/
===========
transition node is not necessary (yipee!!)
"""

from os import listdir
from os import system
from os.path import abspath
from os.path import isdir
from os.path import exists
from os.path import join
from os.path import isabs

from sys import argv
from sys import exit

from mimetypes import guess_type

from datetime import datetime

from getopt import getopt
from getopt import GetoptError

#from argparse import ArgumentParse

######## Constants ###############
EXIT_ERR = 1 #exit code
EXIT_OK = 0 #exit code
TEMP_HEAD_XML = """
<starttime>
  <year>{year}</year>
  <month>{mon}</month>
  <day>{day}</day>
  <hour>{hr}</hour>
  <minute>{minute}</minute>
  <second>{sec}</second>
</starttime>
"""
TEMP_BODY_XML = """
<static>
  <duration>{dur}</duration>
  <file>{filename}</file>
</static>
"""
######## End constants ########

def usage():
  print ("Usage : bgmaker -[h|s] [-i interval] [-o output] [-d directory] [-f files...]")
  print '-h --help'
  print '-i --interval'
  print '-d --directory'
  print '-f --files'
  print '-s --setup (tested and works in 12.04)'
  print '-o output'
  exit(EXIT_ERR)

def verify_img(filename):
  """verify using mimetype. NB file must have extension for this to work"""
  return ('image' in guess_type(filename)[0])

def add_file(file_list, absolute_path):
  if not isdir(absolute_path): #dunno y they r not regular files
    if verify_img(absolute_path):
      file_list.append(absolute_path)

def get_images(directory):
  if not exists(directory):
    print "Folder not found"
    return None
  elif not isdir (directory):
    print "Error : ", directory, " is not a folder"
    return None
  elif not isabs(directory):
    print "Error : directoy should be absolute path"
    return None
  print "Finding images in ", directory, "..."
  files = []
  dir_files = sorted(listdir(directory))
  
  for i in dir_files:
    add_file(files, join(directory, i))
  print "Files found : ", str(len(files))
  return files

def xml_writer(folder, filename, file_list,duration):
  #write output file
  absname = join(folder, filename)
  xml_output = open(absname, "w")
  xml_output.write("<background>") #start node
  date = datetime.now()
  xml_output.write(TEMP_HEAD_XML.format(year=date.year, mon=date.month, day=date.day, hr=date.hour, minute=date.minute, sec=date.second)) #head
  for i in range(0, len(file_list), 1):
    tags = "<file></file>"
    #xml_str = TEMP_BODY_XML.replace(tags, "<file>"+file_list[i]+"</file>")
    xml_str = TEMP_BODY_XML.format(dur=duration, filename=file_list[i])
    xml_output.write(xml_str)
  xml_output.write("</background>") #end node
  xml_output.close()
  print "Config file written to : " + absname
  return absname
  
def install_bg(filename):
  """Setup using absolute filename"""
  #for 12.04 bg is more complex as below
  if not exists(filename):
    print "File not found"
    return False
  elif isdir (filename):
    print "Error : ", filename, " is a folder"
    return False
  elif not isabs(filename):
    print "Error : filename should be absolute path"
    return False  
    
  val = system("gsettings set org.gnome.desktop.background picture-uri 'file://{0}'".format(filename))
  #gsettings in org.gnome.desktop.background
  #color-shading-type  [horizontal|vertical|solid]
  #draw-background     [true] only true is valid
  #picture-opacity   range(0,100)
  #picture-options   [none|wallpaper|centered|scaled|stretched|zoom|spanned]
  #picture-uri      file://abs_path
  #primary-color    string rbg e.g. '#090909' 
  #secondary-color   same as primary color
  #show-desktop-icons  [true|false]
  
  if val == 0:
    return True
  else:
    print 'something wicked happened while setting the background'
    return False
  
def main(files,directory,output='background.xml',interval=30,install=False):
  fyl = xml_writer(directory, output, files, interval)
  if install:
    if install_bg(fyl):
      print 'install succeeded'
    else:
      print 'install failed'
  exit(EXIT_OK)


################ using getopt ############
if __name__ == '__main__':
  if len(argv) < 2:
    print "Try bgmaker -h for usage"
    exit(EXIT_ERR)
    
  interval = 30
  setup = False
  directory = None
  file_list = False
  output_file=None
  files = []
  try:
    opts,args = getopt(argv[1:],"hsfi:d:o:",['--help','--interval=','--directory=','--files','--setup','output='])
    for i,j in opts:
      if i in ('-h','--help'):
        usage()
      elif i in ('-i','--interval'):
        try:
          interval = int(j)
        except:
          print "Invalid interval integer"
          exit(EXIT_ERR)
      elif i in ('-d','--directory'):
        directory = j
      elif i in ('-s','--setup'):
        setup = True
      elif i in ('-f','--files'):
        file_list = True
      elif i in ('-o','--output'):
        output_file = j
      else:
        print "unknown option",i
        exit(EXIT_ERR)
    if file_list:
      for i in args:
        fabs = abspath(i)
        if exists(fabs) and (not isdir(fabs)):
          add_file(files,fabs)    
  except GetoptError,e:
    print str(e)
    usage()

  if (directory is None) and (file_list is False):
    print "no input files specified"
    exit(EXIT_ERR)
  if directory is None:
    print 'directory not set...using CWD'
    directory = '.'
  directory = abspath(directory)

  if not file_list:
    files = get_images(directory)
  if output_file is None:
    print "output file not set...using background.xml"
    output_file = 'background.xml'
  if files is None or len(files)==0:
    print "no valid image files found"
    exit(EXIT_ERR)
    
  main(files,directory,output=output_file,interval=interval,install=setup)


#################using argparse########
  
#if __name__ == '__main__':
#  if len(argv) > 1:
#    sw_filter(argv[1])
#  else:
#    print "Try bgmaker -h for usage"
#    exit(EXIT_ERR)

