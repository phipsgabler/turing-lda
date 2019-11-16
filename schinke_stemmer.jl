# latin stemmer from https://snowballstem.org/otherapps/schinke/

const QUE = r"que$"
const SPECIAL_LETTERS = r"j|v"
const QUE_EXCEPTIONS = r"((at)|(quo)|(ne)|(ita)|(abs)|(aps)|(abus)|(adae)|(adus)|(deni)|(de)|(sus)|(obli)|(perae)|(plenis)|(quando)|(quis)|(quae)|(cuius)|(cui)|(m)|(quam)|(qua)|(qui)|(quorum)|(quarum)|(quibus)|(quos)|(quas)|(quotusquis)|(quous)|(ubi)|(undi)|(us)|(uter)|(uti)|(utro)|(utribi)|(tor)|(co)|(conco)|(contor)|(detor)|(deco)|(exco)|(extor)|(obtor)|(optor)|(retor)|(reco)|(attor)|(inco)|(intor)|(praetor))que$"
const NOUN_SUFFIXES = r"((ibus)|(ius)|(ae)|(am)|(as)|(em)|(es)|(ia)|(is)|(nt)|(os)|(ud)|(um)|(us)|(a)|(e)|(i)|(o)|(u))$"
const VERB_SUFFIX_REPLACEMENTS = [r"iuntur$" => "i",
                                  r"beris$" => "bi",
                                  r"erunt$" => "i",
                                  r"untur$" => "i",
                                  r"iunt$" => "i",
                                  r"mini$" => "",
                                  r"ntur$" => "",
                                  r"stis$" => "",
                                  r"bor$" => "bi",
                                  r"ero$" => "eri",
                                  r"mur$" => "",
                                  r"mus$" => "",
                                  r"ris$" => "",
                                  r"sti$" => "",
                                  r"tis$" => "",
                                  r"tur$" => "",
                                  r"unt$" => "i",
                                  r"bo$" => "bi",
                                  r"ns$" => "",
                                  r"nt$" => "",
                                  r"ri$" => "",
                                  r"m$" => "",
                                  r"r$" => "",
                                  r"s$" => "",
                                  r"t$"  => ""]


@inline function map_letter(c)
    if c == "j"
        return "i"
    elseif c == "v"
        return "u"
    else
        return c
    end
end

@inline map_letters(word) = replace(word, SPECIAL_LETTERS => map_letter)


@inline function replace_verb_suffix(word)
    for (suffix, replacement) in VERB_SUFFIX_REPLACEMENTS
        if endswith(word, suffix)
            return replace(word, suffix => replacement)
        end
    end

    return word
end


function schinke_stemmer(word)
    word = lowercase(word)
    word = map_letters(word)

    if endswith(word, QUE)
        if !isnothing(match(QUE_EXCEPTIONS, word))
            return word
        else
            word = chop(word, tail = 3)
        end
    end

    word = replace(word, NOUN_SUFFIXES => "")
    length(word) ≥ 2 && return word
    
    word = replace_verb_suffix(word)
    return word
end
