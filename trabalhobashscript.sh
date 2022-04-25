RED=$'\e[0;31m'
Blue=$'\033[0;34m'
nocolor=$'\033[0m'
Purple=$'\033[0;35m'
Green=$'\033[0;32m'
Yellow=$'\033[0;33m'
Cyan=$'\033[0;36m'
start=`date +%s`
opcao1=0
opcao2=0
opcao3=0
opcao4=0
opcao5=0
opcao6=0
menu() {
        clear

        if [ "${EUID:-$(id -u)}" != 0 ];
        then echo "Executa o programa como root para teres acesso a todas as opções."
        else

        getusers() {
            opcao1+=1
            users=$(cat /etc/passwd | grep /bin/bash | cut -d: -f1)
            for i in $users
            do
                hash=$(cat /etc/shadow | grep "$i" | cut -d: -f2)
                echo ""$i" : "$hash""
            done
            echo "Prime uma tecla para continuar: "
            read -rsn1
                clear
                menu
            
        }

        verifyauth() {
            opcao2+=1
            failed=$(cat /home/user/Desktop/auth.log | grep "Invalid" | cut -d: -f4 | awk {print'$3'})
            for i in $failed
            do
                time=$(cat /home/user/Desktop/auth.log | grep "$i" | cut -c 1-16 )
                echo " "$i" : "$time" "
            done
            echo "Prime uma tecla para continuar: "
            read -rsn1
                clear
                menu
        }


        checknewerfiles() {
            opcao3+=1
            echo "Insere a pasta onde deseja procurar: (Deves inserir todo o caminho para a mesma)"
            read pasta
            echo "Insere a data a partir da qual queres procurar: (FORMATO YYYY-MM-DD)"
            read data
            echo "Insere a hora a partir da qual queres procurar: (FORMATO HH:MM)"
            read hora
            encontrar=$(find $pasta -type f -newermt ''$data' '$hora'')
            if [ -d "$pasta" ]; then
                echo "$encontrar"
            else
                echo "Essa pasta não existe ou o caminho definido está errado."
            fi
            echo "Prime uma tecla para continuar: "
            read -rsn1
                clear
                menu
        }

        get_directory_diskusage() {
            opcao4+=1
            echo "Insere a pasta onde deseja procurar: (Deves inserir todo o caminho para a mesma)"
            read pasta
            totaldiskusage=$(du -mh -ch $pasta)
            if [ -d "$pasta" ]; then
                echo "$totaldiskusage"
            else
                echo "Essa pasta não existe ou o caminho definido está errado."
            fi
            echo "Prime uma tecla para continuar: "
            read -rsn1
                clear
                menu
        }

        exportallfunctions() {
            opcao5+=1
            #Primeira Funcao
            echo "Insere o nome do ficheiro em que desejas guardar o relatório: "
            read filename
            users=$(cat /etc/passwd | grep /bin/bash | cut -d: -f1)
            for i in $users
            do
                hash=$(cat /etc/shadow | grep "$i" | cut -d: -f2)
                echo ""$i" : "$hash"" >> $filename.txt
            done

            #Adiciona resultados da 2a funcao no fim do ficheiro

            failed=$(cat /home/user/Desktop/auth.log | grep "Invalid" | cut -d: -f4 | awk {print'$3'})
            for i in $failed
            do
                time=$(cat /home/user/Desktop/auth.log | grep "$i" | cut -c 1-16 )
                echo " "$i" : "$time" " >> $filename.txt
            done

            #Adiciona resultados da 3a funcao no fim do ficheiro
            echo "Insere a pasta onde deseja procurar: (Deves inserir todo o caminho para a mesma) (Script de ficheiros mais recentes.)"
            read pasta
            echo "Insere a data a partir da qual queres procurar: (FORMATO YYYY-MM-DD)"
            read data
            echo "Insere a hora a partir da qual queres procurar: (FORMATO HH:MM)"
            read hora
            encontrar=$(find $pasta -type f -newermt ''$data' '$hora'')
            if [ -d "$pasta" ]; then
                echo "$encontrar" >> $filename.txt
            else
                echo "Essa pasta não existe ou o caminho definido está errado. (Script de ficheiros mais recentes.)"
            fi

            #Adiciona resultados da 4a funcao no fim do ficheiro
            echo "Insere a pasta onde deseja procurar: (Deves inserir todo o caminho para a mesma) (Script de espaço usado)"
            read pasta
            totaldiskusage=$(du -mh -ch $pasta)
            if [ -d "$pasta" ]; then
                echo "$totaldiskusage" >> $filename.txt
            else
                echo "Essa pasta não existe ou o caminho definido está errado.(Script de espaço usado)"
            fi

            echo "Relatório guardado!" em "$PWD"

            echo "Prime uma tecla para continuar: "
            read -rsn1
                clear
                menu

        }

        get_script_time() {
            opcao6+=1
            if [ $opcao1 -gt 0 ]; then
                echo "A Opção 1 foi utilizada"
            elif [ $opcao2 -gt 0 ]; then
                echo "A Opção 2 foi utilizada"
            elif [ $opcao3 -gt 0 ]; then
                echo "A Opção 3 foi utilizada"
            elif [ $opcao4 -gt 0 ]; then
                echo "A Opção 4 foi utilizada"
            elif [ $opcao5 -gt 0 ]; then
                echo "A Opção 5 foi utilizada"
            elif [ $opcao6 -gt 0 ]; then
                echo "A Opção 6 foi utilizada"
            fi
            end=`date +%s`
            seconds=`expr $end - $start`
            echo "Script foi utilizado durante $((seconds/60)) minutos e $((seconds%60)) segundos"
            exit
        }



    echo "${RED} a. Opção 1 – Identificar Utilizadores do Sistema${nocolor}"
    echo "${Blue} b. Opção 2 – Identificar tentativas de login falhadas${nocolor}"
    echo "${Purple} c. Opção 3 – Últimos ficheiros alterados${nocolor}"
    echo "${Green} d. Opção 4 – Calcular espaço em disco utilizado${nocolor}" 
    echo "${Yellow} e. Opção 5 – Criar Relatório${nocolor}"
    echo "${Cyan} f. Opção 6 – Sair do Programa${nocolor}"
    echo "Escolha uma opção: "

    read resposta

    if [ "$resposta" = "a" ] || [ "$resposta" = "1" ]; then
        getusers
    elif [ "$resposta" = "b" ] || [ "$resposta" = "2" ]; then
        verifyauth
    elif [ "$resposta" = "c" ] || [ "$resposta" = "3" ]; then
        checknewerfiles
    elif [ "$resposta" = "d" ] || [ "$resposta" = "4" ]; then
        get_directory_diskusage
    elif [ "$resposta" = "e" ] || [ "$resposta" = "5" ]; then
        exportallfunctions
    elif [ "$resposta" = "f" ] || [ "$resposta" = "6" ]; then
        get_script_time
    else
        echo "Resposta inválida."
    fi
    fi
}

menu