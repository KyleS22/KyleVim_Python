"""
File Name: 

Authors: Kyle Seidenthal

Date: 18-08-2019

Description: A module containing functionality for handling PEP8 warnings

"""

import vim

def check_pep8(report_list):
    
    current_buffer = vim.current.buffer
   
    for msg in report_list:
        msg_parts = _get_msg_parts(msg)
        
        line_num = int(msg_parts[1])
        char_num = int(msg_parts[2])
        description = msg_parts[3]
        
        # Ignore leading space and get the error code
        error_type = description.split(" ")[1]
    
        line = current_buffer[line_num-1]
         
        # TODO: The match command is not doing anything
        if error_type[0] == "E":
            vim.command("match PEP8Error /" + line + "/")
        else:
            vim.command("match PEP8Warn /" + line + "/")
   
     
        
def _get_msg_parts(msg):
    
    msg_parts = msg.split(":")
    return msg_parts

