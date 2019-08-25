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
    :raises IOException: If the given line_num is not able to be cast to
                         integer
    """

    try:
        line_num = int(line_num)
    except Exception as e:
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
    Insert an auto-generated docstring for a function whose definition starts
    on line_num

    :param line_num: The line number that the function definition is on
    :returns: None
    """

    # Get the line
    current_buffer = vim.current.buffer
    line = current_buffer[line_num-1]

    # Check for multi-line function definitions
    temp_line_num = line_num + 1
    while line.endswith(","):
        line += " " + current_buffer[temp_line_num-1].lstrip()
        temp_line_num += 1

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

    inside_class = _check_inside_class(line_num)

    for p in params:
        if p == "":
            continue

        default_val = None

        # Check for default values
        if "=" in p:
            parts = p.split("=")
            p = parts[0]
            default_val = parts[1]

        # Don't include self param in class docstrings
        if inside_class:
            if p == "self":
                continue

        if default_val is not None:
            docstring.append(":param " + p + ": {% A parameter %}  The default"
                             + " value is " + default_val + ".")
        else:
            docstring.append(":param " + p + ": {% A parameter %}")

    docstring.append(":returns: {% A thing %}")
    docstring.append("\"\"\"")

    for i in range(len(docstring)):
        docstring[i] = spaces + docstring[i]

    # Insert the docstring to the current buffer
    current_buffer.append(docstring, temp_line_num-1)


def _insert_class_docstring(line_num):
    """
    Insert a docstring header for the class at line_num

    :param line_num: The line number the class definition is on
    :returns: None
    """
    # Get the line
    current_buffer = vim.current.buffer

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
    Returns a string with the correct indentation for the docstring.
    Append this string to docstring lines to get the
    right indentation

    :param line_num: The line number to check
    :returns: A string with a number of spaces representing the
    correct indentation for this docstring
    """
    indent = int(vim.eval("indent(" + str(line_num) + ")")) + 4

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


def _check_inside_class(line_num):
    """
    Checks to see if the given line number is inside of a class definition

    :param line_num: The line number to check
    :returns: True if the line is inside a class definition, false otherwise
    """
    result = vim.eval("search ('class *',  'bnWz')")

    if result != 0:
        func_indent = int(vim.eval("indent(" + str(line_num) + ")"))
        class_indent = int(vim.eval("indent(" + str(result) + " )"))

        # If the class indent is four less than the function, then the function
        # is determined to be inside the class
        if (class_indent + 4) == func_indent:
            return True
        else:
            return False

