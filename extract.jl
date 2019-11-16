using LightXML
import LightXML: child_elements

child_elements(x::Union{XMLElement, XMLNode}, name::AbstractString) =
    (XMLElement(n) for n in child_nodes(x) if is_elementnode(n) && LightXML.name(n) == name)

xdoc = parse_file("epigrammata.tei")
xroot = root(xdoc)
xbody = find_element(find_element(xroot, "text"), "body")
books = child_elements(xbody, "div1")

open("epigrams.txt", "w") do ef
    for book in books
        epigrams = child_elements(book, "div2")
        for epigram in epigrams
            isnothing(match(r"^[0-9]+$", attribute(epigram, "n"))) && continue
            lines = child_nodes(find_element(epigram, "p"))
            for node in lines
                !is_textnode(node) && continue
                line = content(node)
                content == "\n"
                words = (lowercase(m.match) for m in collect(eachmatch(r"\w+", line)))
                join(ef, words, ' ')
            end
            write(ef, '\n')
        end
    end
end
