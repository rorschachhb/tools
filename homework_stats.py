# coding: utf8

import xlrd, xlwt
import os
import sys

PAPER_HW_NUM = 8
PAPER_HW_PPH = 10.0 / PAPER_HW_NUM
CODING_HW_NUM = 10
CODING_HW_PPH = 40.0 / CODING_HW_NUM

def read_coding_score(homework_id, score_dic):
	filename = str(homework_id) + '_score.xls'
	if not os.path.exists(filename):
		print 'file ' + filename + ' does not exist, skipping'
		return score_dic
	wb = xlrd.open_workbook(filename)
	table = wb.sheet_by_name('score')
	for i in range(1, table.nrows):
		row = table.row_values(i)
		sid = row[0]
		score = row[4]
		if sid not in score_dic:
			score_dic[sid] = {}
		score_dic[sid][homework_id] = score
	return score_dic

def read_paper_score(classname):
	filename = classname + '_reencode.xls'
	wb = xlrd.open_workbook(filename)
	table = wb.sheet_by_index(0)
	pos = (7, 9, 11, 13, 16, 17, 19, 21)
	score_dic = {}
	for i in range(1, table.nrows):
		row = table.row_values(i)
		sid = row[0]
		score = []
		for i in range(8):
			try:
				s = int(row[pos[i]])
			except ValueError:
				s = 0
			score.append(s)
		score_dic[sid] = score
	return score_dic

def write_all_score(classname, paper_score_dic, coding_score_dic):
	wb = xlwt.Workbook()
	table = wb.add_sheet('complete stats')
	table.write(0, 0, 'sid')
	for i in range(CODING_HW_NUM):
		table.write(0, i + 1, 'coding %d' % (i + 1))
	for i in range(PAPER_HW_NUM):
		table.write(0, CODING_HW_NUM + 1 + i, 'paper %d' % (i + 1))
	table.write(0, PAPER_HW_NUM + CODING_HW_NUM + 2, 'coding total')
	table.write(0, PAPER_HW_NUM + CODING_HW_NUM + 3, 'paper total')

	stulist = sorted(paper_score_dic.keys(), reverse=True)
	counter = 0
	for sid in stulist:
		counter += 1
		coding_total = 0
		paper_total = 0
		table.write(counter, 0, sid)
		for i in range(CODING_HW_NUM):
			if sid in coding_score_dic and 12 + i in coding_score_dic[sid]:
				s = coding_score_dic[sid][12 + i]
			else:
				s = 0
			table.write(counter, i + 1, str(s))
			coding_total += CODING_HW_PPH / 100 * s
		for i in range(PAPER_HW_NUM):
			s = paper_score_dic[sid][i]
			table.write(counter, CODING_HW_NUM + 1 + i, str(s))
			paper_total += PAPER_HW_PPH / 10 * s
		table.write(counter, PAPER_HW_NUM + CODING_HW_NUM + 2, str(coding_total))
		table.write(counter, PAPER_HW_NUM + CODING_HW_NUM + 3, str(paper_total))

	wb.save(classname + '_stats.xls')



coding_score_dic = {}
for i in range(12, 20):
	coding_score_dic = read_coding_score(i, coding_score_dic)

for classname in ('bai', 'chen', 'wu'):
	paper_score_dic = read_paper_score(classname)
	write_all_score(classname, paper_score_dic, coding_score_dic)

