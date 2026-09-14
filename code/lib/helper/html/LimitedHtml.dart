import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

final _htmlEscape = HtmlEscape(HtmlEscapeMode.element);

class LimitedHtml {
  LimitedHtml({required this.allowedTagNames});
  final Set<String> allowedTagNames;

  String filter(String html) {
    final buffer = StringBuffer();
    final document = html_parser.parseFragment(html);
    _visitNodes(buffer, document.nodes);

    return buffer.toString().trim();
  }

  void _visitNodes(StringSink sink, List<Node> nodes) {
    for (final node in nodes) {
      if (node is Element) {
        _visitElement(sink, node);
      } else if (node is Text) {
        sink.write(_htmlEscape.convert(node.text));
      }
    }
  }

  void _visitElement(StringSink sink, Element element) {
    final tag = element.localName!.toLowerCase();

    if (allowedTagNames.contains(tag)) {
      sink.write('<$tag>');
      _visitNodes(sink, element.nodes);
      sink.write('</$tag>');
    } else {
      sink.write(element.text);
    }
  }
}
