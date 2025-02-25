myint = 5
myfloat = 13.2
mystr = "This is a string"
mybool = True
mylist = [0, 1, "Two", 3.2, False]
mytuple = (0, 1, 2)
mydict = {"one" : 1, "two" : 2}

# print(myint)
# print(myfloat)
# print(mystr)
# print(mybool)
# print(mylist)
# print(mytuple)
# print(mydict)

# re-declaring a variable 
# myint = "abc"
# print(myint)

# accessing a sequance type
# print(mylist[2])
# print(mytuple[1])

# use slice to get part of the sequence 
# print(mylist[1:5])
# print(mylist[1:5:2])

# reversing the sequence 
# print(mylist[::-1])

# dictionary are accesses via keys
# print(mydict["two"])

# varible of diffrent type can't be combine 
# print("String type" + str(123))

# Global Vs Local Variable
def someFunction():
    global mystr
    mystr = "def"
    print(mystr)

someFunction()
print(mystr)

del mystr
print(mystr)