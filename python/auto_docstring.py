"""
File Name:

Authors: Kyle Seidenthal

Date: 11-08-2019

Description: A set of functions that allow auto population of python docstrings

"""

import vim

def insert_docstring(line_num):
    """
    Insert an auto-populated docstring for the line at line_num
    
    :param line_num: The line number to insert the docstring for
    :returns: None
    :raises IOException: If the given line_num is not able to be cast to integer
    """
      
    try:
        line_num = int(line_num)
    except:
        raise IOException("You must give a line number.")

    header_type = _check_header_type(line_num)


    if header_type is None:
        return False

    elif header_type == "FUNC":
        _insert_function_docstring(line_num)

    elif header_type == "CLASS":
        _insert_class_docstring(line_num)


def _insert_function_docstring(line_num):
    """
    Insert an auto-generated docstring for a function whose definition starts on line_num
    
    :param line_num: The line number that the function definition is on
    :returns: None
    """
   
    # Get the line
    current_buffer = vim.current.buffer
    line = current_buffer[line_num-1]
   
    # Parse function name and params
    parts = line.split("(")

    params = parts[1]
    params = params.split(")")[0]
    params = params.split(", ")

    # indent the docstring under the function
    
    spaces = _check_indentation(line_num)
    
    # Build the docstring
    
    docstring = ["\"\"\""]
    docstring.append("{% What it do %}")
    docstring.append("")
    
    for p in params:
        docstring.append(":param " + p + ": {% A parameter %}")
        

    docstring.append(":returns: {% A thing %}")
    docstring.append("\"\"\"")

    for i in range(len(docstring)):
        docstring[i] = spaces + docstring[i]

    # Insert the docstring to the current buffer
    current_buffer.append(docstring, line_num)     


def _insert_class_docstring(line_num):
    """
    Insert a docstring header for the class at line_num
    
    :param line_num: The line number the class definition is on
    :returns: None
    """
    # Get the line
    current_buffer = vim.current.buffer
    line = current_buffer[line_num-1]
   
    spaces = _check_indentation(line_num)

    docstring = ["\"\"\""]
    docstring.append("{% classy comment here %}")
    docstring.append("\"\"\"")


    for i in range(len(docstring)):
        docstring[i] = spaces + docstring[i]

    # insert docstring
    current_buffer.append(docstring, line_num)


def _check_indentation(line_num):
    """
    Returns a string with the correct indentation for the docstring.  Append this string to docstring lines to get the
    right indentation
    
    :param line_num: The line number to check
    :returns: A string with a number of spaces representing the correct indentation for this docstring
    """
    indent = int(vim.eval("indent("+ str(line_num) + ")")) + 4
    

    spaces = ""
    for i in range(indent):
        spaces += " "

    return spaces


def _check_header_type(line_num):
    """
    Checks the current line to see what type of doscstring header is wanted
    
    :returns: A string representing the type of docstring header that is wanted
              'FUNC' implies a function header
              'CLASS' implies a class header
    """
    
    current_buffer = vim.current.buffer
    line = current_buffer[line_num-1]
    

    if "def" in line:
        return "FUNC"
    elif "class" in line:
        return "CLASS"
    else: 
        return None
