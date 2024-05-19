#pragma once
#include <stdexcept>

template <class T>
class List {
protected:

	struct ListNode
	{
		ListNode* prev;
		ListNode* next;
		T data;

		ListNode() : prev(nullptr), next(nullptr), data(T())
		{

		}


		ListNode(ListNode* prev, ListNode* next, T data) : prev(prev), next(next), data(data)
		{

		}
	};

	struct Iterator
	{
	private:
		ListNode* node;

	public:

		Iterator(ListNode* ptr) : node(ptr)
		{

		}

		//prefix
		Iterator operator++()
		{
			node = node->next;
			return *this;
		}

		ListNode& operator*() const
		{
			return *node;
		}

		friend bool operator!=(const Iterator& a, const Iterator& b)
		{
			return a.node != b.node;
		}
	};

	int size_;
	//Warning! 
	//next in guard means first element
	//prev means last element
	//it is due to whole list "looping" correctly, like tank's tracks
	ListNode guard;

public:
	List() : size_(0), guard(ListNode())
	{
		guard.next = &guard;
		guard.prev = &guard;
	}

	ListNode& getGuard()
	{
		return guard;
	}

	//Iterator related functions
	Iterator begin()
	{
		return Iterator(guard.next);
	}

	Iterator end()
	{
		return Iterator(&guard);
	}

	//push needs no data save, because guard already covers access
	void push_front(T x)
	{
		guard.next = new ListNode(&guard, guard.next, x); //initialize and put first element
		guard.next->next->prev = guard.next; //link first element with second
		++size_;
	}
	T pop_front()
	{
		//error handling
		if (empty())
		{
			throw std::out_of_range("EMPTY");
		}

		T res = guard.next->data;
		ListNode* temp = guard.next;
		guard.next = guard.next->next;
		guard.next->prev = &guard;
		delete temp;
		--size_;
		return res;
	}
	void push_back(T x)
	{
		guard.prev = new ListNode(guard.prev, &guard, x); //initialize and put last element
		guard.prev->prev->next = guard.prev; //link last element with second-last
		++size_;
	}
	T pop_back()
	{
		//error handling
		if (empty())
		{
			throw std::out_of_range("EMPTY");
		}

		T res = guard.prev->data;
		ListNode* temp = guard.prev;
		guard.prev = guard.prev->prev;
		guard.prev->next = &guard;
		delete temp;
		--size_;
		return res;
	}
	int size()
	{
		return size_;
	}
	bool empty()
	{
		return size_ == 0;
	}
	void clear()
	{
		//ok crazy idea, just iterate througth everything and pop it until end
		while (!empty())
		{
			pop_front();
		}
	}
	Iterator find(T x)
	{
		//for (auto i : *this)
		for (Iterator it = begin(), end_ = end(); it != end_; ++it)
		{
			ListNode i = *it;
			if (i.data == x)
			{
				return it;
			}
		}
		throw 10;
	}

	T erase(Iterator i)
	{
		T res = (*i).data;
		(*i).prev->next = (*i).next;
		(*i).next->prev = (*i).prev;
		delete& (*i);
		--size_;
		return res;
	}

	void insert(Iterator i, T x)
	{
		(*i).prev = new ListNode((*i).prev, &(*i), x);
		//made linking
		(*i).prev->prev->next = (*i).prev;
		++size_;
	}

	int remove(T x)
	{
		int count = 0;
		while (1)
		{
			Iterator i;
			try
			{
				i = find(x);
			}
			catch (const int message)
			{
				break;
			}
			erase(i);
			++count;
		}
		return count;
	}

	//debugging function, currently unused
	T getIt(Iterator i)
	{
		return (*i).data;
	}
};