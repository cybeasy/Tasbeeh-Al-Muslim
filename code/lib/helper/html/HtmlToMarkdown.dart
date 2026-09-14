import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

final _htmlEscape = HtmlEscape(HtmlEscapeMode.element);

class HtmlToMarkdown {
  String convert(String html) {
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
        sink.write(_htmlEscape.convert(node.text.trim()));
      }
    }
  }

  void _visitElement(StringSink sink, Element element) {
    final tag = element.localName!.toLowerCase();

    switch (tag) {
      case 'p':
        sink.writeln();
        sink.writeln();
        _visitNodes(sink, element.nodes);
        break;
      case 'strong':
        sink.write(' **');
        _visitNodes(sink, element.nodes);
        sink.write('** ');
        break;
      case 'em':
        sink.write(' _');
        _visitNodes(sink, element.nodes);
        sink.write('_ ');
        break;
      default:
        _visitNodes(sink, element.nodes);
        break;
    }
  }
}
