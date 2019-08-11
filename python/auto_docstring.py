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

    print(header_type)

def _check_header_type(line_num):
    """
    Checks the current line to see what type of doscstring header is wanted
    
    :returns: A string representing the type of docstring header that is wanted
              'FUNC' implies a function header
              'CLASS' implies a class header
    """
    
    current_buffer = vim.current.buffer
    line = current_buffer[line_num]
    
    if "def" in line:
        return "FUNC"
    elif "class" in line:
        return "CLASS"
    else: 
        return None
