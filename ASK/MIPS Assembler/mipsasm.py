#! /usr/bin/env python
# ASK Projekt 1
# Assembler MIPS - Zadanie 1
# Adam Kufel
# Wrocław 2018

#------------------------DANE------------------------------------#

#obsługiwane operandy:
#dla typu R: (operand, func) opcode = 0
RoperandDict = {'add':32,'addu':33,'sub':34,'subu':35,'and':36,'or':37,'nor':39,'div':26,'divu':27,
'mult':24,'multu':25,'mflo':18,'mfhi':16,'slt':42,'sltu':43,'sll':0,'srl':2,'xor':38,'sra':3,'sllv':4,
'srlv':6,'srav':7,'mthi':17,'mtlo':19}

#dla typu I: (operand, opcode)
IoperandDict = {'lui':15,'addi':8,'addiu':9,'andi':12,'ori':13,'slti':10,'sltiu':11,'xori':14}

#Zamiana symboli rejestrów:
RegSymbolsDict = {'$zero':0,'$at':1,'$v0':2,'$v1':3,'$a0':4,'$a1':5,'$a2':6,'$a3':7,'$t0':8,'$t1':9,'$t2':10,
    '$t3':11,'$t4':12,'$t5':13,'$t6':14,'$t7':15,'$s0':16,'$s1':17,'$s2':18,'$s3':19,'$s4':20,'$s5':21,'$s6':22,'$s7':23,
    '$t8':24,'$t9':25,'$k0':26,'$k1':27,'$gp':28,'$sp':29,'$fp':30,'$ra':31}


#----------------------WCZYTYWANIE DANYCH------------------------#
#formatowanie do listy par [(<instrukcja>, <'operand1,operand2'...'>)]
File = open('tests.txt','r').read()
Datalines = File.split('\n')
Formattedlines = [] 
for dataline in Datalines:
    dataline = (dataline.split(' ')[0],dataline.split(' ')[1])
    Formattedlines.append(dataline)

#----------------------KONWERSJA NA NUMERY REJESTRÓW-------------#

#funkcja konwertująca nazwy i symbole rejestrów do numerów
# argumenty w postaci np.: '$t0,$s3,$s2'
def RegisterSymbolsConvert(arguments):
    arguments = arguments.split(',')
    ConvertedSymbols = []
    for arg in arguments:
        if arg in RegSymbolsDict:  #gdy jest na liście symboli
            ConvertedSymbols.append(RegSymbolsDict[arg])
            continue
        elif '$' in arg:        #przypadek dla $1, $3, itd.
            ConvertedSymbols.append(int(arg.replace('$','')))
            continue
        else: #przypadek dla stałych: -12, 4, itd.
            ConvertedSymbols.append(int(arg))
    return ConvertedSymbols


#-------------------------KONWERSJE DO FORMATOW R i I---------------#

# przykladowe argumenty: 32,'$s0,$s1,$s2'; zwracana wartosc: 02328020 
def RConverter(func,arguments):    
    HexWordResult = '000000' #opcode = 0 dla typu R
    arguments = RegisterSymbolsConvert(arguments)
    #przypadek dla sll, sra, srl
    if func == 0 or func == 2 or func == 3:
        HexWordResult += '00000'
        HexWordResult += format(arguments[1],'05b')        
        HexWordResult += format(arguments[0],'05b')
        HexWordResult += format(arguments[2] if arguments[2] >= 0 else (1 << 5) + arguments[2], '05b')#shaml
    #przypadek dla div,divu,mult,multu - 2 argumenty
    elif func >=24 and func <=27:
        HexWordResult += format(arguments[0],'05b')
        HexWordResult += format(arguments[1],'05b')
        HexWordResult += '0000000000'         
    #przypadek dla mflo, mfhi= 1 argument
    elif func == 16 or func == 18:
        HexWordResult += '0000000000'
        HexWordResult += format(arguments[0],'05b')
        HexWordResult += '00000'
    #przypadek dla mtlo, mthi= 1 argument
    elif func == 17 or func == 19:
        HexWordResult += format(arguments[0],'05b')
        HexWordResult += '000000000000000'
    #przypadek dla sllv, srlv, srav
    elif func ==7 or func == 6 or func == 4:
        HexWordResult += format(arguments[2],'05b')
        HexWordResult += format(arguments[1],'05b')        
        HexWordResult += format(arguments[0],'05b')
        HexWordResult += '00000'#shaml =0          
    else:
        HexWordResult += format(arguments[1],'05b')
        HexWordResult += format(arguments[2],'05b')
        HexWordResult += format(arguments[0],'05b')
        HexWordResult += '00000'#shaml = 0 wpp
    HexWordResult += format(func,'06b')     #doklejamy func na koncu
    return '%08X' % (int(HexWordResult,2))


def IConverter(opcode, arguments):
    # przykladowe argumenty: 32,'$t0,$s3,-12'; zwracana wartosc: 2268FFF4 
    arguments = RegisterSymbolsConvert(arguments)
    IHexWordResult = format(opcode,'06b')
    #przypadek dla lui - 2 argumenty
    if opcode == 15:
        IHexWordResult += '00000'
        IHexWordResult += format(arguments[0],'05b')
        IHexWordResult += format(arguments[1] if arguments[1] >= 0 else (1 << 16) + arguments[1], '016b')
    else:
        IHexWordResult += format(arguments[1],'05b')
        IHexWordResult += format(arguments[0],'05b')
        IHexWordResult += format(arguments[2] if arguments[2] >= 0 else (1 << 16) + arguments[2], '016b')
    return '%08X' % (int(IHexWordResult,2))
    


#--------------------FUNKCJA MAIN------------------#
def Program():
    WordAdress =''
    Address = 0
    StringAdress=''
    i=0
    for line in Formattedlines:
        if line[0] in RoperandDict:
            WordAdress = RConverter(RoperandDict[line[0]], line[1])
        else:
            WordAdress = IConverter(IoperandDict[line[0]], line[1])
        StringAdress = '%08X' % (int(format(Address, '032b'),2))
        print  (StringAdress + "      " + WordAdress + "     " + Datalines[i])
        i+=1
        Address += 4

Program()
input()
