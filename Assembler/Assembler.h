#pragma once
#include <bits/stdc++.h>
using namespace std;

class Assembler {
	vector<bitset<16>> mem;
	map<string, int> reg;
	map<string, int> oneOp, twoOp, memOp, brOp;
	const vector<string> oneOP_ = { "nop" , "not", "inc", "dec", "out", "in" };
	const vector<string> twoOP_ = { "swap" , "add", "iadd", "sub", "and", "or", "shl", "shr"};
	const vector<string> memOP_ = { "push" , "pop", "ldm", "ldd", "std"};
	const vector<string> brOp_ = { "jz" , "jmp", "call", "ret", "rti"};

	int hex_int(string s) {
		stringstream h(s);
		int imm;
		h >> std::hex >> imm;
		return imm;
	}
	
public:

	Assembler() {
		for (int i = 0; i <= 7; ++i) {
			string r = "r";
			r.push_back(i + '0');
			reg[r] = i;
		}

		for (int i = 0; i < (int)oneOP_.size(); ++i) {
			oneOp[oneOP_[i]] = i;
		}

		for (int i = 0; i < (int)twoOP_.size(); ++i) {
			twoOp[twoOP_[i]] = i;
		}

		for (int i = 0; i < (int)memOP_.size(); ++i) {
			memOp[memOP_[i]] = i;
		}

		for (int i = 0; i < (int)brOp_.size(); ++i) {
			brOp[brOp_[i]] = i;
		}
	}

	void encode(string file_name) {
		ifstream cin(file_name);
		string s;

		int cntOrg = 0;
		while (1) {
			getline(cin, s);
			if (s == "") continue;
			stringstream ss(s);
			cntOrg++;
			string f;
			vector<string> v;
			while (ss >> f) {
				transform(f.begin(), f.end(), f.begin(), ::tolower);
				v.push_back(f);
			}
			int idx = hex_int(v[1]);
			while (int(mem.size()) < idx) mem.push_back(0);
			if (cntOrg == 3) break;
			getline(cin, s);
			while (s == "") continue;
			bitset<16> val(hex_int(s));
			mem.push_back(val);
		}

		while (getline(cin,s)) {

			if (s == "") continue;
			//replce any comma with space
			for (int i = 0; i < (int)s.size(); ++i) s[i] = s[i] == ',' ? ' ' : s[i];
			stringstream ss(s);
			vector<string> instr;
			string f;
			while (ss >> f) {
				transform(f.begin(), f.end(), f.begin(), ::tolower);
				instr.push_back(f);
			}
			if (instr[0] == "nop") continue;
			bitset<16> b;
			if (oneOp.count(instr[0])) {
				bitset<3> op(oneOp[instr[0]]);
				b[13] = op[2], b[12] = op[1], b[11] = op[0];
				bitset<3> Rdst(reg[instr[1]]);
				b[10] = b[7] = b[4] = Rdst[2], b[9] = b[6] = b[3] = Rdst[1], b[8] = b[5] = b[2] = Rdst[0]; // Rdst in Rsrc1 & Rsrc2...
				mem.push_back(b);
			}
			else if (twoOp.count(instr[0])) {
				b[14] = 1;
				bitset<3> op(twoOp[instr[0]]);
				b[13] = op[2], b[12] = op[1], b[11] = op[0];
				if (instr[0] == "iadd") {
					bitset<3> Rsrc1(reg[instr[2]]) , Rdst(reg[instr[1]]);
					b[10] = Rdst[2], b[9] = Rdst[1], b[8] = Rdst[0];
					b[7] = Rsrc1[2], b[6] = Rsrc1[1], b[5] = Rsrc1[0];
					b[1] = 1; // extend
					bitset<16> imm(hex_int(instr[3]));
					mem.push_back(b);
					mem.push_back(imm);

				}
				else if (instr[0] != "swap" && instr[0] != "shr" && instr[0] != "shl") {
					bitset<3> Rsrc1(reg[instr[2]]), Rsrc2(reg[instr[3]]), Rdst(reg[instr[1]]);
					b[10] = Rdst[2], b[9] = Rdst[1], b[8] = Rdst[0];
					b[7] = Rsrc1[2], b[6] = Rsrc1[1], b[5] = Rsrc1[0];
					b[4] = Rsrc2[2], b[3] = Rsrc2[1], b[2] = Rsrc2[0];
					mem.push_back(b);
				}
				else if (instr[0] != "swap") {
					bitset<3> Rdst(reg[instr[1]]);
					b[10] = b[7] = b[4] = Rdst[2], b[9] = b[6] = b[3] = Rdst[1], b[8] = b[5] = b[2] = Rdst[0];
					b[1] = 1; // extend
					bitset<16> imm(hex_int(instr[2]));
					mem.push_back(b);
					mem.push_back(imm);
				}
				else {
					bitset<3> Rsrc1(reg[instr[2]]), Rsrc2(reg[instr[1]]), Rdst(reg[instr[1]]);
					b[10] = Rdst[2], b[9] = Rdst[1], b[8] = Rdst[0];
					b[7] = Rsrc1[2], b[6] = Rsrc1[1], b[5] = Rsrc1[0];
					b[4] = Rsrc2[2], b[3] = Rsrc2[1], b[2] = Rsrc2[0];
					mem.push_back(b);
				}
			}
			else if (memOp.count(instr[0])) {
				b[15] = 1;
				bitset<3> op(memOp[instr[0]]);
				b[13] = op[2], b[12] = op[1], b[11] = op[0];
				if (instr[0] == "push" || instr[0] == "push") {
					bitset<3> Rdst(reg[instr[1]]);
					b[10] = b[7] = b[4] = Rdst[2], b[9] = b[6] = b[3] = Rdst[1], b[8] = b[5] = b[2] = Rdst[0]; // Rdst in Rsrc1 & Rsrc2...
					mem.push_back(b);
				}
				else if (instr[0] == "ldm") {
					bitset<3> Rdst(reg[instr[1]]);
					b[10] = Rdst[2], b[9] = Rdst[1], b[8] = Rdst[0];
					b[1] = 1; // extend
					bitset<16> imm(hex_int(instr[2]));
					mem.push_back(b);
					mem.push_back(imm);
				}
				else {
					bitset<3> Rdst(reg[instr[1]]);
					b[10] = Rdst[2], b[9] = Rdst[1], b[8] = Rdst[0];
					b[1] = 1; // extend
					bitset<20> EA(hex_int(instr[2]));
					b[7] = EA[19], b[6] = EA[18], b[5] = EA[17];
					b[0] = EA[16]; // EA cont
					mem.push_back(b);
					bitset<16> bb; //16 bit EA
					for (int i = 15; i >= 0; --i) bb[i] = EA[i];
					mem.push_back(bb);
				}

			}
			else {
				b[15] = b[14] = 1;
				bitset<3> op(brOp[instr[0]]);
				b[13] = op[2], b[12] = op[1], b[11] = op[0];
				if (instr[0] != "ret" && instr[0] != "rti") {
					bitset<3> Rdst(reg[instr[1]]);
					b[10] = b[7] = b[4] = Rdst[2], b[9] = b[6] = b[3] = Rdst[1], b[8] = b[5] = b[2] = Rdst[0]; // Rdst in Rsrc1 & Rsrc2...
				}
				mem.push_back(b);
			}
		}
	}

	void output(string file_name) {
		ofstream cout(file_name);
		for (auto i : mem) cout << i << endl;
	}



};
