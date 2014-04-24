    TEXFILE="tex/table_qap_`date +%s`.tex"
    touch $TEXFILE || exit -1

    ALGORITHMS="inicial greedy-v1 greedy-v2 2-opt"
    DATAFILES="$1"

    echo -n "\\begin{center}
    \\begin{longtabu} to \linewidth{ l | *4{d{0}}}  % máx 10 decimales
\rowfont\bfseries Datos " > $TEXFILE

    for alg in $ALGORITHMS; do
        printf "& \multicolumn{1}{l}{$alg}" >> $TEXFILE
    done

    echo "\\\\ \\hline
    \endhead
    \endfoot
    \\\\ \\hline
    \endlastfoot" >> $TEXFILE

    for file in $DATAFILES; do
        echo -n "$file " >> $TEXFILE
        RESULTS=`src/qap.rb $file | grep "Coste:" | cut -d" " -f2`
        for res in $RESULTS; do
            echo -n "& $res " >> $TEXFILE
        done
        echo "\\\\" >> $TEXFILE
    done

    echo "
    \\end{longtabu}
\\end{center}" >> $TEXFILE