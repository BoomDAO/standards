import A "mo:base/AssocList";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Char "mo:base/Char";
import Error "mo:base/Error";
import Float "mo:base/Float";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Map "mo:base/HashMap";
import Int "mo:base/Int";
import Int16 "mo:base/Int16";
import Int8 "mo:base/Int8";
import Iter "mo:base/Iter";
import L "mo:base/List";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Prelude "mo:base/Prelude";
import Prim "mo:prim";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/Trie";
import Trie2D "mo:base/Trie";

import JSON "../utils/Json";
import Utils "../utils/Utils";

module {
    public class Configs(_configs : Trie.Trie<Text, JSON.JSON>) {
        public var remote_configs : Trie.Trie<Text, JSON.JSON> = _configs;
        //CRUD
        public func createConfig(name : Text, json : Text) : async (Result.Result<Text, Text>) {
            switch (JSON.parse(json)) {
                case (?j) {
                    remote_configs := Trie.put(remote_configs, Utils.keyT(name), Text.equal, j).0;
                    return #ok(json);
                };
                case _ {
                    return #err("json parse error");
                };
            };
        };

        public func updateConfig(name : Text, json : Text) : async (Result.Result<Text, Text>) {
            switch (Trie.find(remote_configs, Utils.keyT(name), Text.equal)) {
                case (?_) {
                    switch (JSON.parse(json)) {
                        case (?j) {
                            remote_configs := Trie.put(remote_configs, Utils.keyT(name), Text.equal, j).0;
                            return #ok(json);
                        };
                        case _ {

                            return #err("json parse error");
                        };
                    };
                };
                case _ {

                    return #err("config not found");
                };
            };
        };

        public func getConfig(name : Text) : async (Text) {
            switch (Trie.find(remote_configs, Utils.keyT(name), Text.equal)) {
                case (?j) {
                    return JSON.show(j);
                };
                case _ {
                    return "json not found";
                };
            };
        };

        public func deleteConfig(name : Text) : async (Result.Result<Text, Text>) {
            switch (Trie.find(remote_configs, Utils.keyT(name), Text.equal)) {
                case (?_) {
                    remote_configs := Trie.remove(remote_configs, Utils.keyT(name), Text.equal).0;
                    return #ok("removed " #name);
                };
                case _ {
                    return #err("config not found");
                };
            };
        };
    };
};