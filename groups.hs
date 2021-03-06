{-

	haskell-groups - Group oriented programming in Haskell
	BSD license.
	by Sven Nilsen, 2013
	http://www.cutoutpro.com

	Version: 0.000 in angular degrees version notation
	http://isprogrammingeasy.blogspot.no/2012/08/angular-degrees-versioning-notation.html

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of the FreeBSD Project.

-}

-- This function is used for accessing all the indices contained by a group. 
group_Index :: 		[Int] -> [Int]
group_Index [] =        []
group_Index (a:b:rest) =
                       	[a .. (b - 1)] ++ group_Index rest

-- Returns the smallest value of two lists.
group_Min :: 		[Int] -> [Int] -> Int
group_Min (a:_) (b:_) =	min a b

-- Advances a list if 'i' matches the first.
group_Next :: 		[Int] -> Int -> [Int]
group_Next (a:rest) i =	if a == i then rest else a:rest

-- Joins two groups together with Boolean Union operation (Or).
group_Or ::		[Int] -> [Int] -> [Int]
group_Or a b =		group_Or' a b False False False
			where
			group_Or' :: [Int] -> [Int] -> Bool -> Bool -> Bool -> [Int]
			group_Or' [] [] hasA hasB was = []
			group_Or' a [] hasA hasB was = a
			group_Or' [] b hasA hasB was = b
			group_Or' a b hasA hasB was =
				(if has' /= was then [min] else []) ++ 
				group_Or' a' b' hasA' hasB' has'
				where
				min = group_Min a b
				a' = (group_Next a min)
				b' = (group_Next b min)
				hasA' = if (a!!0 == min) then not hasA else hasA
				hasB' = if (b!!0 == min) then not hasB else hasB
				has' = hasA' || hasB'

-- Joins two groups together with Boolean Intersect operation (And).
group_And ::		[Int] -> [Int] -> [Int]
group_And a b =		group_And' a b False False False
			where
			group_And' :: [Int] -> [Int] -> Bool -> Bool -> Bool -> [Int]
			group_And' [] [] hasA hasB was = []
			group_And' a [] hasA hasB was = []
			group_And' [] b hasA hasB was = []
			group_And' a b hasA hasB was =
				(if has' /= was then [min] else []) ++ 
				group_And' a' b' hasA' hasB' has'
				where
				min = group_Min a b
				a' = (group_Next a min)
				b' = (group_Next b min)
				hasA' = if (a!!0 == min) then not hasA else hasA
				hasB' = if (b!!0 == min) then not hasB else hasB
				has' = hasA' && hasB'

-- Joins two groups together with Boolean Subtract operation (Except).
group_Except ::		[Int] -> [Int] -> [Int]
group_Except a b =	group_Except' a b False False False
			where
			group_Except' :: [Int] -> [Int] -> Bool -> Bool -> Bool -> [Int]
			group_Except' [] [] hasA hasB was =	[]
			group_Except' a [] hasA hasB was = a
			group_Except' [] b hasA hasB was = []
			group_Except' a b hasA hasB was =
				(if has' /= was then [min] else []) ++ 
				group_Except' a' b' hasA' hasB' has'
				where
				min = group_Min a b
				a' = (group_Next a min)
				b' = (group_Next b min)
				hasA' = if (a!!0 == min) then not hasA else hasA
				hasB' = if (b!!0 == min) then not hasB else hasB
				has' = hasA' && (not hasB')

-- Computes the size of a group.
group_Size ::		[Int] -> Int
group_Size [] =		0
group_Size (a:b:rest) = b - a + group_Size rest

-- Filters a list using a group.
group_Filter a g =	group_Filter' a g_index
			where
			g_index = group_Index g
			group_Filter' [] [] = []
			group_Filter' a [] = []
			group_Filter' a (g:g_rest) = 
				if g >= (length a) then []
				else [a !! g] ++ (group_Filter' a g_rest)

-- Returns a group of the even items.
group_Even ::		() -> [Int]
group_Even () = 	group_Even' 0
			where
			group_Even' i = [i,(i+1)] ++ group_Even' (i+2)

-- Returns a group of the odd items.
group_Odd ::		() -> [Int]
group_Odd () = 		group_Odd' 1
			where
			group_Odd' i = [i,(i+1)] ++ group_Odd' (i+2)

-- Removes equal numbers from group, which has no effect since they cancel each other.
group_RemoveDuplicates :: [Int] -> [Int]
group_RemoveDuplicates [] = []
group_RemoveDuplicates a =
			first ++ group_RemoveDuplicates rest
			where
			same = if length a == 1 then False else a!!0 == a!!1
			first = if same then [] else [head a]
			rest = if same then drop 2 a else tail a

-- Transforms a group 'b' into the internal index space of 'a'.
-- This method is useful when a group filters a list and you want other groups to do it as well.
group_Transform ::	[Int] -> [Int] -> [Int]
group_Transform a b =	group_RemoveDuplicates (group_Transform' a b False False False 0 0)
			where
			group_Transform' :: [Int] -> [Int] -> Bool -> Bool -> Bool -> Int -> Int -> [Int]
			group_Transform' [] [] hasA hasB was offset last = []
			group_Transform' a [] hasA hasB was offset last = []
			group_Transform' [] b hasA hasB was offset last = []
			group_Transform' a b hasA hasB was offset last =
				(if has' /= was then [min - offset'] else []) ++ 
				(group_Transform' a' b' hasA' hasB' has' offset' last')
				where
				min = (group_Min a b)
				a' = (group_Next a min)
				b' = (group_Next b min)
				hasA' = if (a!!0 == min) then not hasA else hasA
				hasB' = if (b!!0 == min) then not hasB else hasB
				offset' = if hasA' && (a!!0 == min) then offset + min - last else offset
				has' = hasA' && hasB'
				last' = if has' /= was then min else last


