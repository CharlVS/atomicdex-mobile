import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AddressBookProvider extends ChangeNotifier {
  AddressBookProvider() {
    _init();
  }

  String clipboard;

  Future<List<Contact>> get contacts async {
    while (_contacts == null) {
      await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    }

    return _contacts;
  }

  Contact contactByAddress(String address) {
    if (_contacts == null) return null;

    Contact found;
    for (Contact contact in _contacts) {
      contact.addresses?.forEach((String abbr, String value) {
        if (value == address) found = contact;
      });
    }

    return found;
  }

  void updateContact(Contact contact) {
    final Contact existing = _contacts.firstWhere(
      (Contact c) => c.uid == contact.uid,
      orElse: () => null,
    );

    if (existing != null) {
      existing.name = contact.name;
      existing.addresses = contact.addresses;
      _saveContacts();
      notifyListeners();
    }
  }

  Contact createContact({
    String name,
    Map<String, String> addresses,
  }) {
    final Contact contact = Contact.create(name, addresses);
    _contacts.add(contact);
    _saveContacts();
    notifyListeners();

    return contact;
  }

  void deleteContact(Contact contact) {
    _contacts.remove(contact);
    _saveContacts();
    notifyListeners();
  }

  SharedPreferences _prefs;
  List<Contact> _contacts;

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadContacts();
  }

  void _loadContacts() {
    String saved;
    try {
      saved = _prefs.getString('addressBook');
    } catch (_) {}

    if (saved == null) {
      _contacts = [];
    } else {
      final List<dynamic> json = jsonDecode(saved);
      final List<Contact> contactsFromJson = [];
      for (dynamic contact in json) {
        contactsFromJson.add(Contact.fromJson(contact));
      }

      _contacts = contactsFromJson;
    }

    notifyListeners();
  }

  void _saveContacts() {
    final List<dynamic> json = <dynamic>[];

    for (Contact contact in _contacts) {
      json.add(contact.toJson());
    }

    _prefs.setString('addressBook', jsonEncode(json));
  }
}

class Contact {
  Contact({
    this.uid,
    this.name,
    this.addresses,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    Map<String, String> addresses;
    json['addresses']?.forEach((String key, dynamic value) {
      addresses ??= {};
      addresses[key] = value;
    });

    return Contact(
      name: json['name'],
      uid: json['uid'],
      addresses: addresses,
    );
  }

  factory Contact.create(
    String name,
    Map<String, String> addresses,
  ) =>
      Contact(
        name: name,
        addresses: addresses,
        uid: Uuid().v1(),
      );

  Map<String, dynamic> toJson() {
    Map<String, String> addresses;
    this.addresses?.forEach((String key, String value) {
      addresses ??= {};
      addresses[key] = value;
    });

    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'addresses': addresses,
    };
  }

  String uid;
  String name;
  Map<String, String> addresses;
}
