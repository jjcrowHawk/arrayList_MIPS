#include<stdio.h>
#include<stdlib.h>
#define MAX 20 //número máximo de elementos en la lista

//variables
struct
{
int list[MAX]; //arreglo
int element; //nuevo elemento para agregar
int pos; //posicion del elemento a agregar o eliminar
int length; //longitud del arreglo
}l;

//enumeración para poder usar booleanos en vez de numeros
enum boolean { true, false };
typedef enum boolean boolean;

//funciones
int menu(void); //funcion para ver el menu del programa
void create(void); //funcion para crear el arreglo
void insert(int, int); //funcion para agregar un elemento en una posicion dada
void delete(int); //funcion para eliminar un elemento en una posicion dada
void find(int); //funcion para encontrar la posicion de un elemento dado
void display(void); //funcion para presentar el arreglo
void average(void); //funcion para encontrar el promedio del arreglo 
boolean islistfull(void); //funcion para verificar si el arreglo está lleno
boolean islistempty(void); //funcion para verificar si el arreglo está vacío

void main()
{
    int ch;
    int element;
    int pos;
    l.length = 0;
    while(1)
    {
        ch = menu();
        switch (ch)
        {
            case 1:
                l.length = 0;
                create();
                break;
            case 2:
                if (islistfull() != true)
                {
                    printf("\tEnter the New element : ");
                    scanf("%d", &element);
                    printf("\tEnter the Position : ");
                    scanf("%d", &pos);
                    insert(element, pos);
                }
                else
                {
                    printf("\tList if Full. Cannot insert\n");     
                }
                break;
            case 3:
                if (islistempty() != true)
                {
                    printf("Enter the position of element to be deleted : ");
                    scanf("%d", &pos);
                    delete(pos);
                }
                else
                {
                    printf("List is Empty.\n");
                }
                break;
            case 4:
            	if (islistempty() != true)
                {
                	printf("No. of elements in the list is %d\n", l.length);
                }
                else
                {
                    printf("List is Empty.\n");
                }
                break;
            case 5:
            	if (islistempty() != true)
                {
	                printf("Enter the element to be searched : ");
	                scanf("%d", &element);
	                find(element);
                }
                else
                {
                    printf("List is Empty.\n");
                }
                break;
            case 6:
            	if (islistempty() != true)
                {
                	display();
                }
                else
                {
                    printf("List is Empty.\n");
                }
                break;
            case 7:
            	if (islistempty() != true)
                {
            		average();
            	}
            	else
                {
                    printf("List is Empty.\n");
                }
            	break;
            case 8:
                exit(0);
                break;
            default:
                printf("Invalid Choice\n");
                
        }
    }
}

//funcion para ver el menu del programa
int menu()
{
    int ch;
    printf("\n\t\t********************************************\n");
    printf("\t\t******LIST Implementation Using Arrays******\n");
    printf("\t\t********************************************\n\n");
    printf("\t1. Create\n\t2. Insert\n\t3. Delete\n\t4. Count\n\t5. Find\n\t6. Display\n\t7. Average\n\t8. Exit\n\n\tEnter your choice : ");
    scanf("%d", &ch);
    printf("\n\n");
    return ch;
}

//funcion para crear el arreglo
void create(void)
{
    int element;
    int flag=1;	//bandera para indicar si se sigue agregando elementos o no

    //ciclo para agregar varios elementos
    while(flag==1)
    {
        printf("Enter an element : ");
        scanf("%d", &element);
        l.list[l.length] = element;
        printf("\nYou entered: %d \n",l.list[l.length]);
        l.length++;

        //validación para evitar agregar más elementos que el máximo permitido
        if (islistfull() != true)
        {
        	printf("To insert another element press '1' To stop press '0': ");
        	scanf("%d", &flag);
        }
        else
        {
        	printf("\n\tList if Full\n"); 
        	flag = 0;
        }
    }
}

//funcion para presentar el arreglo
void display(void)
{
    int i;
    for (i=0; i<l.length; i++)
    printf("Element %d : %d \n", i+1, l.list[i]);
}

//funcion para agregar un elemento en una posicion dada
void insert(int element, int pos)
{
    int i;

    //validación para evitar la posición cero
    if (pos == 0)
    {
        printf("\n\nCannot insert at zeroth position");
        return;
    }
    //validación para evitar una posición inexistente o que no sea siguiente a la última
    else if (pos-1 > l.length)
    {
        printf("\n\nOnly %d elements exit. Cannot insert at %d postion", l.length, pos);
        return;
    }
    //agregar elemento
    else
    {
        for (i=l.length; i>=pos-1; i--)
        {   
            l.list[i+1] = l.list[i];
        }
        l.list[pos-1] = element;
        l.length++;
        printf("\nElement inserted!!\n");
    }
}

//funcion para eliminar un elemento en una posicion dada
void delete(int pos)
{
    int i;

    //validación para evitar la posición cero
    if(pos == 0)
    {
        printf("\n\nCannot delete at zeroth position");
        return;
    }
    //validación para evitar una posición inexistente
    if (pos > l.length)
    {
        printf("\n\nOnly %d elements exists. Cannot delete %d", l.length, pos);
        return;
    }
    //eliminar elemento
    for (i=pos-1; i<l.length; i++)
    {   
        l.list[i]= l.list[i+1];
    }
    l.length--;
    printf("\nElement deleted!");
}

//funcion para encontrar la posicion de un elemento dado
void find(int element)
{
    int i;
    int flag = 1; //bandera para indicar si se encontró el elemento o no

    //recorrer el arreglo hasta encontrar el elemento
    for (i=0; i<l.length; i++)
    {
        if(l.list[i] == element)
        {
            printf ("%d exists at %d position",element, i+1);
            flag = 0;
            break;
        }
    }
    if(flag == 1)
    {
        printf("Element not found.\n");
    }
}

//funcion para encontrar el promedio del arreglo
void average(void)
{
	int i;
	float avg;
	int sum = 0;

	//recorrer el arreglo para sumar los elementos
	for (i=0; i<l.length; i++)
	{
		sum = sum + l.list[i];
	}

	//calcular el promedio
	avg = (float) sum / (float) l.length;
	printf ("The average is: %f\n", avg);
}

//funcion para verificar si el arreglo está lleno
boolean islistfull(void)
{
    if (l.length == MAX)
        return true;
    else
        return false;
}

//funcion para verificar si el arreglo está vacío
boolean islistempty(void)
{
    if (l.length == 0)
        return true;
    else
        return false;
}