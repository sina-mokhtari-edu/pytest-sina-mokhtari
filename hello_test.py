from __future__ import absolute_import
from __future__ import print_function
import sys
import os
from optparse import OptionParser
import json

# the next line can be removed after installation
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import pyverilog.utils.version
from pyverilog.vparser.parser import parse
from contextlib import redirect_stdout

def main():
    filelist, options = get_filelist()
#==========================THE BELOW SEGMENT MUST BE CHANGE FOR EACH ASSIGNMENT==================
    n_tests = 1
    test_names = ["Memory"]
    structuralAllowed = True
    dataflowAllowed = True
    behavioralAllowed = True
#================================================================================================

    test_ids = range (n_tests)    
    description = "No compile or simulation errors" #TODO Make a list so that every test has its own discription
    test_grades = [0] * n_tests
    test_times = ["..."] * n_tests
    compileError = False
    simError = False
    plagiarism = False
    
    with open('compileLog','r') as f:
        for line in f:
            if line.startswith ("** Error"):
                compileError = True
                description = line;
                test_grades = [0] * n_tests  #TODO Can you compile each part of a question separately?
                break

    #if n_grades exceeds n_tests, then the student has written the same string in his/her design
    n_grades_written_in_test_file = 0; 
    if not compileError:
        with open('simLog','r') as f:
            for line in f:
                if line.startswith ("# ** Error"):
                    if "TA" in line:
                        description = "Your Top module name probably is invalid!"
                    else:
                        description = line;
                    simError = True
                    test_grades = [0] * n_tests  #TODO Can you test each part of a question separately?
                    break
                elif line.startswith ("# grade: "):
                    if n_grades_written_in_test_file >= n_tests:
                        plagiarism = True
                        description = "Plagiarism"
                        test_grades = [0] * n_tests
                        break
                    test_grades [n_grades_written_in_test_file] = float (line.split()[2])
                    n_grades_written_in_test_file += 1

#=======================calling example_parser parse function to parse verilog===========================
    # with redirect_stdout(sys.stderr):
        # if not (compileError or simError or plagiarism):
            # try:
                # ast, directives = parse(filelist,
                                    # preprocess_include=options.include,
                                    # preprocess_define=options.define)

# #==========checking what type of modelling, i.e, structural, dataflow, behavioral, has been used=========
                # from io import StringIO
                # output = StringIO()
                # ast.show(buf=output)
                # out = output.getvalue()
                # structuralUsed = False
                # dataflowUsed = False
                # behavioralUsed = False
                # if 'InstanceList' in out:
                    # structuralUsed = True
                # if 'Assign' in out:
                    # dataflowUsed = True
                # if 'Initial' in out or 'Always' in out:
                    # behavioralUsed = True
                # if (not structuralAllowed and structuralUsed) or (not dataflowAllowed and dataflowUsed) or (
                            # not behavioralAllowed and behavioralUsed):
                    # description = "Illegal modelling has been used."
                    # test_grades = [0] * n_tests
            # except:
                # description = "Could not test if illegal modelling has been used."

#=======================================printing results in json form=====================================
    result = []
    for i in test_ids:
        test_i = {}
        test_i['id'] = i + 1
        test_i['name'] = test_names[i]
        test_i['description'] = description
        test_i['grade_test_100'] = test_grades[i]
        test_i['time'] = test_times[i]
        result.append(test_i)
    print(json.dumps(result))        
#=======================================pyVerilog example_parser.py========================================
def get_filelist():
    with redirect_stdout(sys.stderr):
        INFO = "Verilog code parser"
        VERSION = pyverilog.utils.version.VERSION
        USAGE = "Usage: python example_parser.py file ..."

        def showVersion():
            print(INFO)
            print(VERSION)
            print(USAGE)
            sys.exit()

        optparser = OptionParser()
        optparser.add_option("-v", "--version", action="store_true", dest="showversion",
                             default=False, help="Show the version")
        optparser.add_option("-I", "--include", dest="include", action="append",
                             default=[], help="Include path")
        optparser.add_option("-D", dest="define", action="append",
                             default=[], help="Macro Definition")
        (options, args) = optparser.parse_args()

        filelist = args
        if options.showversion:
            showVersion()

        for f in filelist:
            if not os.path.exists(f): raise IOError("file not found: " + f)

        if len(filelist) == 0:
            showVersion()

    return filelist, options

if __name__ == '__main__':
    main()
